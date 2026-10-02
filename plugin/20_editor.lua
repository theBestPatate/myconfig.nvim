---20_editor — editing helpers: text objects, code-block editing, argument
---swapping, flash navigation, auto-formatting, and surround.

local now, later = Config.now, Config.later

-- Brief yank highlight
Config.new_autocmd('TextYankPost', nil, function()
  vim.hl.on_yank { higroup = 'IncSearch', timeout = 150 }
end, 'Highlight yanked text')

-- Some filetype plugins enable two annoying comment behaviours that we
-- strip back on every FileType event:
--   c  When typing a comment that hits the text-width limit, Vim automatically
--      breaks it onto a new line and inserts a comment prefix — noisy when
--      you're still writing the sentence.
--   o  Pressing 'o' or <Enter> on a comment line copies the comment prefix
--      to the new line — annoying when you want a blank line after a comment.
Config.new_autocmd('FileType', nil, function()
  vim.cmd 'setlocal formatoptions-=c formatoptions-=o'
end, 'Disable comment auto-wrap')

-- 1. Mini editing tools ----------------------------------------------------
later(function()
  require('mini.pairs').setup { modes = { command = true } }
  require('mini.comment').setup()

  -- mini.keymap bindings (Tab/CR/BS in insert mode) are in 02_keymaps.lua
end)

-- Inline hex color preview
now(function()
  vim.pack.add { 'https://github.com/catgoose/nvim-colorizer.lua' }
end)

---Configure and attach colorizer to the current buffer.
---Called both on first install (via on_packchanged) and on subsequent
---startups (via Config.later).
local function setup_colorizer()
  require('colorizer').setup {
    filetypes = { '*' },
    user_default_options = { mode = 'background' },
  }
  vim.cmd 'ColorizerAttachToBuffer'
end

-- Already installed: set up now; first install: set up when PackChanged fires
Config.later(function()
  if pcall(require, 'colorizer') then
    setup_colorizer()
  end
end)
Config.on_packchanged('nvim-colorizer.lua', { 'install' }, setup_colorizer, 'Setup colorizer on first install')

-- Treesitter text objects (af, if, ac, etc.)
Config.new_autocmd('FileType', nil, function()
  local ok, ts_textobjects = pcall(require, 'nvim-treesitter-textobjects')
  if not ok then
    return
  end

  ts_textobjects.setup {
    select = { lookahead = true, selection_modes = { ['@function.outer'] = 'V', ['@class.outer'] = 'V' } },
  }

  local select = require 'nvim-treesitter-textobjects.select'

  -- Treesitter textobject keymaps:  a<key> selects the outer region,
  -- i<key> selects the inner region (excluding delimiters).
  -- Works in visual (x) and operator-pending (o) modes.
  local textobjects = {
    -- functions
    { 'af', '@function.outer' },
    { 'if', '@function.inner' },
    -- classes
    { 'ac', '@class.outer' },
    { 'ic', '@class.inner' },
    -- parameters
    { 'aa', '@parameter.outer' },
    { 'ia', '@parameter.inner' },
    -- conditionals (if/else/etc.)
    { 'ai', '@conditional.outer' },
    { 'ii', '@conditional.inner' },
    -- loops
    { 'al', '@loop.outer' },
    { 'il', '@loop.inner' },
    -- blocks (any {})
    { 'ab', '@block.outer' },
    { 'ib', '@block.inner' },
    -- call expressions
    { 'aC', '@call.outer' },
    { 'iC', '@call.inner' },
  }

  for _, entry in ipairs(textobjects) do
    vim.keymap.set({ 'x', 'o' }, entry[1], function()
      select.select_textobject(entry[2], 'textobjects')
    end, { desc = 'Select ' .. entry[2], buffer = true })
  end
end, 'Treesitter text objects')

-- CodeBlockEdit: dive into a treesitter-injected code block in a dedicated
-- buffer. Saves sync back to the original document. All LSP/treesitter/
-- text-objects work natively because the buffer has the real filetype.
vim.api.nvim_create_user_command('CodeBlockEdit', function(opts)
  local main_buf = vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(main_buf)
  if not parser then
    vim.notify('No treesitter parser for this buffer', vim.log.levels.WARN)
    return
  end
  parser:parse(true)

  local cursor_row, cursor_col = vim.api.nvim_win_get_cursor(0)
  cursor_row = cursor_row - 1

  -- Find injected language at cursor
  local language_tree = parser:language_for_range { cursor_row, cursor_col, cursor_row, cursor_col }
  if not language_tree or language_tree:lang() == parser:lang() then
    vim.notify('Cursor is not inside a code block', vim.log.levels.WARN)
    return
  end
  local lang = language_tree:lang()

  local all_regions = {}

  -- Walk the language tree recursively, collecting every injection region
  -- for the target language (tree is a vim.treesitter.LanguageTree).
  -- Each region is a {start_row, start_col, end_row, end_col} tuple.
  local function collect_regions(tree)
    for child_lang, child_tree in pairs(tree:children()) do
      if child_lang == lang then
        for _, region_list in pairs(child_tree:included_regions()) do
          for _, region in ipairs(region_list) do
            table.insert(all_regions, { unpack(region) })
          end
        end
      end
      collect_regions(child_tree)
    end
  end
  collect_regions(parser)

  if #all_regions == 0 then
    vim.notify('No code blocks found for language: ' .. lang, vim.log.levels.WARN)
    return
  end

  -- Sort and merge contiguous/overlapping regions
  table.sort(all_regions, function(a, b)
    if a[1] == b[1] then
      return a[2] < b[2]
    end
    return a[1] < b[1]
  end)

  local merged = { all_regions[1] }
  for i = 2, #all_regions do
    local last = merged[#merged]
    local current = all_regions[i]
    if current[1] <= last[4] then
      last[4] = math.max(last[4], current[4])
      last[5] = math.max(last[5], current[5])
    else
      table.insert(merged, current)
    end
  end

  -- Find the merged region containing the cursor
  local target_region
  for _, region in ipairs(merged) do
    if cursor_row >= region[1] and cursor_row <= region[4] then
      target_region = region
      break
    end
  end
  if not target_region then
    vim.notify('Could not determine code block boundaries', vim.log.levels.WARN)
    return
  end

  -- Extract text from merged region
  local start_row, start_col, _, end_row, end_col = unpack(target_region)
  local text = vim.api.nvim_buf_get_text(main_buf, start_row, start_col, end_row, end_col, {})

  -- Create child buffer with a real temp file so LSP servers attach
  local child_buf = vim.api.nvim_create_buf(true, false)
  local tmpname = vim.fn.tempname() .. '.' .. lang
  vim.api.nvim_buf_set_name(child_buf, tmpname)
  vim.bo[child_buf].filetype = lang
  vim.bo[child_buf].bufhidden = 'wipe'
  vim.api.nvim_buf_set_lines(child_buf, 0, -1, false, text)

  -- Store back-reference for saving
  vim.b[child_buf].codeblock_main_buf = main_buf
  vim.b[child_buf].codeblock_range = { start_row, start_col, end_row, end_col }

  local augroup = vim.api.nvim_create_augroup('CodeBlockEdit', {})

  -- Clean up temp file on close
  vim.api.nvim_create_autocmd('BufWipeout', {
    buffer = child_buf,
    group = augroup,
    once = true,
    callback = function()
      if tmpname:match '^/tmp/' then
        vim.fn.delete(tmpname)
      end
    end,
  })

  -- Intercept :w to sync back to main buffer
  vim.api.nvim_create_autocmd('BufWriteCmd', {
    buffer = child_buf,
    group = augroup,
    callback = function()
      local edit_buf = vim.api.nvim_get_current_buf()
      local source_buf = vim.b[edit_buf].codeblock_main_buf
      local range = vim.b[edit_buf].codeblock_range
      if not source_buf or not vim.api.nvim_buf_is_valid(source_buf) or not range then
        vim.notify('Original buffer no longer available', vim.log.levels.WARN)
        return
      end
      local new_text = vim.api.nvim_buf_get_lines(edit_buf, 0, -1, false)
      -- Remove trailing empty line from nvim_buf_get_lines
      if #new_text > 0 and new_text[#new_text] == '' then
        table.remove(new_text)
      end
      vim.api.nvim_buf_set_text(source_buf, range[1], range[2], range[3], range[4], new_text)
      vim.bo[edit_buf].modified = false
      vim.schedule(function()
        vim.notify(string.format('Synced %d lines back to original', #new_text), vim.log.levels.INFO)
      end)
    end,
  })

  -- Open in split
  local cmd = opts.bang and 'vsplit' or 'split'
  vim.cmd(cmd)
  vim.api.nvim_win_set_buf(0, child_buf)

  vim.notify(string.format('Editing %s code block (temp file). :w syncs back, :q discards.', lang), vim.log.levels.INFO)
end, { desc = 'Open injected code block in a dedicated buffer', bang = true })

-- Argument swapping via swapping_potato plugin
vim.pack.add { 'https://github.com/theBestPatate/swapping_potato' }
require('swapping_potato').setup()

-- 2. Flash.nvim — fast jump navigation -----------------------------------
-- Keymaps and setup are in 02_keymaps.lua
later(function()
  vim.pack.add { 'https://github.com/folke/flash.nvim' }
end)

-- 3. Conform.nvim — auto-formatting --------------------------------------
later(function()
  vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

  -- Python is formatted and import-sorted by ruff only, using the same
  -- project-local binary as the LSP (see lua/local/ruff.lua). Do NOT add
  -- standalone isort/black here: their defaults (line-length, wrap style)
  -- drift from ruff's and fight the ruff LSP's I001 diagnostic.
  local ruff = require 'local.ruff'

  require('conform').setup {
    notify_on_error = false,
    default_format_opts = {
      lsp_format = 'fallback',
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_fallback = true }
    end,
    formatters_by_ft = {
      python = { 'ruff_format', 'ruff_organize_imports' },
      html = { 'prettierd' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      css = { 'prettierd' },
      rust = { 'rustfmt', 'rust_analyzer' },
    },
    formatters = {
      ruff_format = {
        command = function(_, ctx)
          return ruff.bin(ctx.dirname)
        end,
      },
      ruff_organize_imports = {
        command = function(_, ctx)
          return ruff.bin(ctx.dirname)
        end,
      },
    },
  }

  -- Conform Commands
  vim.api.nvim_create_user_command('ConformDisable', function(args)
    if args.bang then
      vim.b.disable_autoformat = true
    else
      vim.g.disable_autoformat = true
    end
  end, { desc = 'Disable autoformat-on-save', bang = true })

  vim.api.nvim_create_user_command('ConformEnable', function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
  end, { desc = 'Re-enable autoformat-on-save' })

  -- Conform toggle keymaps are in 02_keymaps.lua under <Leader>t
end)

-- 4. Nvim-surround — add/change/delete surrounding pairs -----------------
later(function()
  vim.pack.add { 'https://github.com/kylechui/nvim-surround' }
end)
