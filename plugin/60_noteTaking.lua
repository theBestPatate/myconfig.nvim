---60_noteTaking — markdown preview and note-taking tools.

local now, later = Config.now, Config.later

-- Markview: live markdown preview
now(function()
  vim.pack.add { 'https://github.com/OXY2DEV/markview.nvim' }
end)
Config.later(function()
  if pcall(require, 'markview') then
    require('markview').setup()
  end
end)
Config.on_packchanged('markview.nvim', { 'install' }, function()
  require('markview').setup()
end, 'Setup markview on first install')
