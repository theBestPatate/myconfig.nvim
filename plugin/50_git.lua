local later = Config.later

later(function()
  require('mini.diff').setup {
    view = {
      signs = { add = '▎', change = '▎', delete = '▁' },
    },
  }

  -- Gutter sign colors using chilling potato's strongest accents
  vim.api.nvim_set_hl(0, 'MiniDiffSignAdd', { fg = '#85a781', bg = 'NONE' }) -- sage (strongest green)
  vim.api.nvim_set_hl(0, 'MiniDiffSignChange', { fg = '#7d9598', bg = 'NONE' }) -- diff_change (slate blue)
  vim.api.nvim_set_hl(0, 'MiniDiffSignDelete', { fg = '#c17f84', bg = 'NONE' }) -- diag_error (strongest red)

  -- Git hunk nav (]h, [h) and toggle overlay (<Leader>tg) are in 02_keymaps.lua
end)
