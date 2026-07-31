---
---30_coding.lua — Treesitter, LSP, and completion.
---
---## Treesitter
---Adds nvim-treesitter + nvim-treesitter-textobjects via `vim.pack.add`.
---Pre-installs a small set of "essential" parsers at startup (see `parsers`
---list below); every other parser is auto-installed on first use via a
---`FileType` autocommand — open a `.py` file → python parser downloads
---once in the background, then attaches immediately on subsequent opens.
---
---## LSP
---Adds nvim-lspconfig + mason.nvim.  Enables every server listed in the
---`servers` loop.  Custom server configs live under `after/lsp/<name>.lua`
---and are `dofile`'d; servers without a custom config file get `{}`.
---Keymaps are all under `<Leader>l` (think "LSP"):
---  • `<Leader>la` — code action
---  • `<Leader>ld` — diagnostic popup
---  • `<Leader>li` — go to implementation
---  • `<Leader>lh` — hover
---  • `<Leader>lr` — rename
---  • `<Leader>lR` — references
---  • `<Leader>ls` — go to definition
---
---## Completion
---Sets up mini.completion with LSP omnifunc fallback.  Injects
---mini.completion's LSP capabilities into *every* server via
---`vim.lsp.config("*", ...)` so that servers advertise snippet/
---documentation support matching what the completion engine expects.

local now_if_args, _ = Config.now_if_args, Config.later

-- 1. Treesitter ==============================================================
now_if_args(function()
  Config.on_packchanged('nvim-treesitter', { 'update' }, function()
    vim.cmd 'TSUpdate'
  end, ':TSUpdate')

  vim.pack.add {
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  }

  -- Essential parsers installed eagerly at startup; the rest are
  -- auto-installed on first FileType encounter (see autocommand below).
  local parsers = { 'bash', 'c', 'cpp', 'css', 'html', 'javascript', 'lua', 'markdown', 'markdown_inline', 'python', 'query', 'rust' }
  local installed = require('nvim-treesitter').get_installed 'parsers'
  local to_install = vim.tbl_filter(function(lang)
    return not vim.tbl_contains(installed, lang)
  end, parsers)
  if #to_install > 0 then
    require('nvim-treesitter').install(to_install)
  end

  -- Attach treesitter to a buffer with indent fallback
  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    if not vim.treesitter.language.add(language) then
      return
    end
    vim.treesitter.start(buf, language)

    -- Only enable treesitter indent if the language has indent queries;
    -- otherwise fall back to Vim's built-in indentexpr
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil
    if has_indent_query then
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end

  -- Auto-attach treesitter for any filetype with a parser
  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('custom-treesitter', {}),
    callback = function(args)
      local buf, filetype = args.buf, args.match
      local language = vim.treesitter.language.get_lang(filetype)
      if not language then
        return
      end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'
      if vim.tbl_contains(installed_parsers, language) then
        -- Parser already installed: attach immediately
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- Parser available but not installed: auto-install then attach
        require('nvim-treesitter').install(language):await(function()
          treesitter_try_attach(buf, language)
        end)
      else
        -- Parser not in nvim-treesitter (e.g. custom): try to attach anyway
        treesitter_try_attach(buf, language)
      end
    end,
  })
end)

-- 2. LSP Servers & Mason =====================================================
-- Eager: always run at startup.  The one-time download cost is acceptable;
-- it guarantees servers are ready before the first FileType event fires.

vim.pack.add { 'https://github.com/neovim/nvim-lspconfig' }
vim.pack.add { 'https://github.com/mason-org/mason.nvim' }

require('mason').setup {
  ensure_installed = {
    'bash-language-server',
    'eslint-lsp',
    'lua-language-server',
    'marksman',
    'ruff',
    'rust-analyzer',
    'stylua',
    'tinymist',
    'ty',
    'vtsls',
  },
}

-- Server configs (merged with nvim-lspconfig defaults via vim.lsp.config)
-- Custom configs are loaded from after/lsp/<name>.lua, defaults use {}
local servers = {}
for _, name in ipairs {
  'lua_ls',
  'stylua',
  'tinymist',
  'marksman',
  'vtsls',
  'oxlint',
  'superhtml',
  'ty',
} do
  local cfg = {}
  local cfg_file = vim.fn.stdpath 'config' .. '/after/lsp/' .. name .. '.lua'
  if vim.uv.fs_stat(cfg_file) then
    cfg = dofile(cfg_file)
  end
  servers[name] = cfg
end

for name, cfg in pairs(servers) do
  vim.lsp.config(name, cfg)
  vim.lsp.enable(name)
end

-- LSP keymaps (<leader>la, <leader>ld, …) are in 02_keymaps.lua

-- 3. Autocompletion =======================================================
now_if_args(function()
  require('mini.completion').setup {
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = function(items, base)
        return MiniCompletion.default_process_items(items, base)
      end,
    },
  }

  Config.new_autocmd('LspAttach', nil, function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
  end, "Set 'omnifunc'")

  -- Globally inject mini.completion capabilities into all LSP servers
  vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })
end)

-- 4. Diagnostics display ===================================================
Config.later(function()
  vim.diagnostic.config {
    signs = {
      priority = 9999,
      severity = { min = vim.diagnostic.severity.HINT, max = vim.diagnostic.severity.ERROR },
      text = {
        [vim.diagnostic.severity.ERROR] = '',
        [vim.diagnostic.severity.WARN] = '',
        [vim.diagnostic.severity.INFO] = '',
        [vim.diagnostic.severity.HINT] = '',
      },
    },
    underline = {
      severity = { min = vim.diagnostic.severity.HINT, max = vim.diagnostic.severity.ERROR },
    },
    virtual_lines = false,
    virtual_text = {
      current_line = true,
      severity = { min = vim.diagnostic.severity.ERROR, max = vim.diagnostic.severity.ERROR },
    },
    update_in_insert = false,
  }
end)

now_if_args(function()
  vim.pack.add { 'https://github.com/esmuellert/codediff.nvim' }
end)
