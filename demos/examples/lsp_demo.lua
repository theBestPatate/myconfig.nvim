---@class Config
---@field timeout integer
---@field retries integer

---@type Config
local defaults = {
  timeout = 1000,
  retries = 3,
}

---@class Module
---@field options Config
local M = {}
M.options = {}

---Apply user config on top of defaults
---@param opts table|nil
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", defaults, opts or {})
end

---Reset to factory settings
function M.reset()
  M.options = vim.deepcopy(defaults)
end

return M
