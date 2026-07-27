local now, later = Config.now, Config.later

-- Briefly highlight yanked text
Config.new_autocmd('TextYankPost', nil, function()
  vim.highlight.on_yank { higroup = 'IncSearch', timeout = 150 }
end, 'Highlight yanked text')

-- 1. Text manipulation (Mini tools)
later(function()
  require('mini.pairs').setup { modes = { command = true } }
  require('mini.comment').setup()
  require('mini.move').setup()
  require('mini.splitjoin').setup()
  require('mini.align').setup()
  require('mini.trailspace').setup()
  require('mini.operators').setup()

  -- Autocompletion menu & Auto-pairs navigation
  require('mini.keymap').setup()
  MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
  MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
  MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
  MiniKeymap.map_multistep('i', '<BS>', { 'minipairs_bs' })
end)

-- Inline hex color preview
now(function()
  vim.pack.add { 'https://github.com/catgoose/nvim-colorizer.lua' }
end)
Config.later(function()
  local ok, colorizer = pcall(require, 'colorizer')
  if not ok then
    return
  end
  colorizer.setup {
    filetypes = { '*' },
    user_default_options = { mode = 'background' },
  }
  vim.cmd 'ColorizerAttachToBuffer'
end)

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    local ts_textobjects = require 'nvim-treesitter-textobjects'

    ts_textobjects.setup {
      select = { lookahead = true, selection_modes = { ['@function.outer'] = 'V', ['@class.outer'] = 'V' } },
    }

    local select = require 'nvim-treesitter-textobjects.select'

    local function sel(key, capture)
      vim.keymap.set({ 'x', 'o' }, key, function()
        select.select_textobject(capture, 'textobjects')
      end, { desc = 'Select ' .. capture, buffer = true })
    end

    -- Selections (buffer-local)
    sel('af', '@function.outer')
    sel('if', '@function.inner')
    sel('ac', '@class.outer')
    sel('ic', '@class.inner')
    sel('aa', '@parameter.outer')
    sel('ia', '@parameter.inner')
    sel('ai', '@conditional.outer')
    sel('ii', '@conditional.inner')
    sel('al', '@loop.outer')
    sel('il', '@loop.inner')
    sel('ab', '@block.outer')
    sel('ib', '@block.inner')
    sel('aC', '@call.outer')
    sel('iC', '@call.inner')
  end,
})

-- CodeBlockEdit: dive into a treesitter-injected code block in a dedicated buffer.
-- Saves sync back to the original document. All LSP/treesitter/text-objects
-- work natively because the buffer has the real filetype.
vim.api.nvim_create_user_command('CodeBlockEdit', function(opts)
  local main_buf = vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(main_buf)
  if not parser then
    vim.notify('No treesitter parser for this buffer', vim.log.levels.WARN)
    return
  end
  parser:parse(true)

  local row, col = vim.api.nvim_win_get_cursor(0)
  row = row - 1

  -- Find injected language at cursor
  local lt = parser:language_for_range { row, col, row, col }
  if not lt or lt:lang() == parser:lang() then
    vim.notify('Cursor is not inside a code block', vim.log.levels.WARN)
    return
  end
  local lang = lt:lang()

  -- Collect all injection regions for this language, merge contiguous ones
  local all_regions = {}
  local function collect_regions(t)
    for child_lang, child_tree in pairs(t:children()) do
      if child_lang == lang then
        for _, rl in pairs(child_tree:included_regions()) do
          for _, r in ipairs(rl) do
            table.insert(all_regions, { unpack(r) })
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

  -- Sort and merge contiguous regions
  table.sort(all_regions, function(a, b)
    if a[1] == b[1] then
      return a[2] < b[2]
    end
    return a[1] < b[1]
  end)

  local merged = { all_regions[1] }
  for i = 2, #all_regions do
    local last = merged[#merged]
    local cur = all_regions[i]
    -- Adjacent or overlapping: merge
    if cur[1] <= last[4] then
      last[4] = math.max(last[4], cur[4])
      last[5] = math.max(last[5], cur[5])
    else
      table.insert(merged, cur)
    end
  end

  -- Find the merged region containing the cursor
  local target_region = nil
  for _, r in ipairs(merged) do
    if row >= r[1] and row <= r[4] then
      target_region = r
      break
    end
  end
  if not target_region then
    vim.notify('Could not determine code block boundaries', vim.log.levels.WARN)
    return
  end

  -- Extract text from merged region
  local sr, sc, _, er, ec = unpack(target_region)
  local text = vim.api.nvim_buf_get_text(main_buf, sr, sc, er, ec, {})

  -- Create child buffer with a real temp file so LSP servers (ty, etc.) attach
  local child_buf = vim.api.nvim_create_buf(true, false)
  local tmpname = vim.fn.tempname() .. '.' .. lang
  vim.api.nvim_buf_set_name(child_buf, tmpname)
  vim.bo[child_buf].filetype = lang
  vim.bo[child_buf].bufhidden = 'wipe' -- auto-delete when hidden
  vim.api.nvim_buf_set_lines(child_buf, 0, -1, false, text)

  -- Store back-reference for saving
  vim.b[child_buf].codeblock_main_buf = main_buf
  vim.b[child_buf].codeblock_range = { sr, sc, er, ec }

  local augroup = vim.api.nvim_create_augroup('CodeBlockEdit', {})

  -- Clean up temp file on close (capture name now, buffer won't be valid later)
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
      local cb = vim.api.nvim_get_current_buf()
      local mb = vim.b[cb].codeblock_main_buf
      local rng = vim.b[cb].codeblock_range
      if not mb or not vim.api.nvim_buf_is_valid(mb) or not rng then
        vim.notify('Original buffer no longer available', vim.log.levels.WARN)
        return
      end
      local new_text = vim.api.nvim_buf_get_lines(cb, 0, -1, false)
      -- Remove trailing empty line from nvim_buf_get_lines
      if #new_text > 0 and new_text[#new_text] == '' then
        table.remove(new_text)
      end
      vim.api.nvim_buf_set_text(mb, rng[1], rng[2], rng[3], rng[4], new_text)
      -- Mark as saved
      vim.bo[cb].modified = false
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

-- Argument swap: delegated to swapping_potato plugin.
require('swapping_potato').setup()

-- 2. Flash.nvim (Priority over 's')
later(function()
  vim.pack.add { 'https://github.com/folke/flash.nvim' }
  require('flash').setup {}

  local map = vim.keymap.set
  map({ 'n', 'x', 'o' }, '<leader>s', function()
    require('flash').jump()
  end, { desc = 'Flash Jump' })
  map({ 'n', 'x', 'o' }, '<leader>S', function()
    require('flash').treesitter_search()
  end, { desc = 'Treesitter Search' })
  map('o', 'r', function()
    require('flash').remote()
  end, { desc = 'Remote Flash' })
end)

-- 3. Conform.nvim (Autoformatter)
later(function()
  vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

  require('conform').setup {
    notify_on_error = false,
    default_format_opts = {
      lsp_format = 'fallback',
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      local disable_filetypes = { c = false, cpp = false }
      return { timeout_ms = 500, lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype] }
    end,
    formatters_by_ft = {
      python = { 'black', 'isort' },
      html = { 'prettierd' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      css = { 'prettierd' },
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

  -- Conform Keymaps (Using 'c' for code to avoid 't' terminal conflict)
  vim.keymap.set('n', '<leader>cf', function()
    if vim.b.disable_autoformat then
      vim.cmd 'ConformEnable'
      vim.notify 'Enabled autoformat for current buffer'
    else
      vim.cmd 'ConformDisable!'
      vim.notify 'Disabled autoformat for current buffer'
    end
  end, { desc = 'Toggle autoformat for current buffer' })

  vim.keymap.set('n', '<leader>cF', function()
    if vim.g.disable_autoformat then
      vim.cmd 'ConformEnable'
      vim.notify 'Enabled autoformat globally'
    else
      vim.cmd 'ConformDisable'
      vim.notify 'Disabled autoformat globally'
    end
  end, { desc = 'Toggle autoformat globally' })
end)

-- 4. Nvim-surround
later(function()
  vim.pack.add { 'https://github.com/kylechui/nvim-surround' }
end)
