-- Enable Lua module caching for faster startup
vim.loader.enable()

---@class Config
---Global helpers shared across all plugin files (stored in _G.Config).
---Uses mini.misc.safely() for error-tolerant scheduling.
_G.Config = {}

-- Bootstrap mini.nvim to use its module loading helpers
vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

local misc = require('mini.misc')

---Execute function immediately with error handling.
---@param f function
Config.now = function(f) misc.safely('now', f) end

---Defer function via vim.schedule with error handling.
---@param f function
Config.later = function(f) misc.safely('later', f) end

---Execute immediately if nvim was launched with file arguments,
---otherwise defer. Used to prioritize plugin loading when opening
---a file vs. empty startup.
---@type function
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later

---Schedule function to run on a Neovim event.
---Examples: 'event:InsertEnter', 'event:CmdlineEnter~/', 'filetype:lua'.
---@param ev string  Event specification (see mini.misc.safely docs)
---@param f  function
Config.on_event = function(ev, f) misc.safely('event:' .. ev, f) end

-- Autocommand helper — all autocmds share the 'custom-config' augroup
local gr = vim.api.nvim_create_augroup('custom-config', {})

---Create an autocmd in the shared 'custom-config' augroup.
---@param event    string  Neovim event (e.g. 'FileType', 'LspAttach')
---@param pattern  string|string[]|nil  Event pattern(s)
---@param callback function
---@param desc     string  Human-readable description
Config.new_autocmd = function(event, pattern, callback, desc)
  vim.api.nvim_create_autocmd(event, { group = gr, pattern = pattern, callback = callback, desc = desc })
end

---Run callback when a vim.pack.add plugin is loaded or updated.
---Listens for PackChanged events and matches by plugin name and kind.
---@param plugin_name string   Plugin name (e.g. 'nvim-treesitter')
---@param kinds        string[] Event kinds to match (e.g. {'update', 'install'})
---@param callback     function
---@param desc         string   Autocommand description
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  Config.new_autocmd('PackChanged', '*', function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback()
  end, desc)
end

-- Convenience command to update all plugins and the lock file
vim.api.nvim_create_user_command('PackUpdate', function()
  vim.pack.update()
end, { desc = 'Update all plugins to latest versions' })

---Wipe ALL cached plugins, parsers, and the lock file.
---On next launch vim.pack.add will reinstall everything from scratch.
vim.api.nvim_create_user_command('PackWipe', function()
  local data = vim.fn.stdpath('data')
  local config = vim.fn.stdpath('config')
  local paths = {
    ('%s/site/pack'):format(data),
    ('%s/site/parser'):format(data),
    ('%s/site/parser-info'):format(data),
    ('%s/site/queries'):format(data),
    ('%s/lazy'):format(data),
    ('%s/nvim-pack-lock.json'):format(config),
  }
  local deleted = {}
  for _, p in ipairs(paths) do
    if vim.uv.fs_stat(p) then
      vim.fn.delete(p, 'rf')
      table.insert(deleted, p)
    end
  end
  if #deleted == 0 then
    vim.notify('PackWipe: nothing to delete', vim.log.levels.INFO)
  else
    vim.notify(
      'PackWipe: deleted\n  ' .. table.concat(deleted, '\n  ') .. '\nRestart nvim to reinstall.',
      vim.log.levels.WARN
    )
  end
end, { desc = 'Wipe all cached plugins, parsers, and lock file' })
