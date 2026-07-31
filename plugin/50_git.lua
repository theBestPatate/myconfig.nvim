local later = Config.later

later(function()
  -- Gitsigns (from your requested merge)
  vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim' }
  require('gitsigns').setup {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  }

  -- Mini Diff
  require('mini.diff').setup()

  -- Hunk nav keymaps (]h, [h) are in 02_keymaps.lua; <Leader>tg is there too
end)
