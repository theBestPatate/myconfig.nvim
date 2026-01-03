return {
  -- NOTE: All git commands directly from neovim
  { 'tpope/vim-sleuth', enabled = true }, -- Detect tabstop and shiftwidth automatically
  { 'tpope/vim-fugitive', enabled = true }, --GIT

  {
    -- NOTE: show indent lines
    'lukas-reineke/indent-blankline.nvim',
    enabled = true,
    main = 'ibl',
    opts = {
      indent = { char = '│' },
    },
  },
  { 'jpalardy/vim-slime', enabled = true },
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>tf',
        function()
          -- If autoformat is currently disabled for this buffer,
          -- then enable it, otherwise disable it
          if vim.b.disable_autoformat then
            vim.cmd 'ConformEnable'
            vim.notify 'Enabled autoformat for current buffer'
          else
            vim.cmd 'ConformDisable!'
            vim.notify 'Disabled autoformat for current buffer'
          end
        end,
        desc = 'Toggle autoformat for current buffer',
      },
      {
        '<leader>tF',
        function()
          -- If autoformat is currently disabled globally,
          -- then enable it globally, otherwise disable it globally
          if vim.g.disable_autoformat then
            vim.cmd 'ConformEnable'
            vim.notify 'Enabled autoformat globally'
          else
            vim.cmd 'ConformDisable'
            vim.notify 'Disabled autoformat globally'
          end
        end,
        desc = 'Toggle autoformat globally',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        local disable_filetypes = { c = false, cpp = false }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'black', 'isort' },
        javascript = { { 'prettierd', 'prettier' } },
        typescript = { { 'prettierd', 'prettier' } },
        typescriptreact = { { 'prettierd', 'prettier' } },
        javascriptreact = { { 'prettierd', 'prettier' } },
        css = { { 'prettierd', 'prettier' } },
        cs = { 'csharpier' },
      },
    },
    config = function(_, opts)
      require('conform').setup(opts)

      vim.api.nvim_create_user_command('ConformDisable', function(args)
        if args.bang then
          -- :ConformDisable! disables autoformat for this buffer only
          vim.b.disable_autoformat = true
        else
          -- :ConformDisable disables autoformat globally
          vim.g.disable_autoformat = true
        end
      end, {
        desc = 'Disable autoformat-on-save',
        bang = true, -- allows the ! variant
      })

      vim.api.nvim_create_user_command('ConformEnable', function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = 'Re-enable autoformat-on-save',
      })
    end,
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration
      'nvim-telescope/telescope.nvim', -- optional
    },
    { -- generate docstrings
      'danymat/neogen',
      cmd = { 'Neogen' },
      dependencies = 'nvim-treesitter/nvim-treesitter',
      config = true,
    },
  },
}
