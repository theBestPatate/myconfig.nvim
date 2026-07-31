local later = Config.later

later(function()
  require('mini.diff').setup()

  -- Git hunk nav (]h, [h) and toggle overlay (<Leader>tg) are in 02_keymaps.lua
end)
