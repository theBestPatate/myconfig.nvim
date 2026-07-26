-- Collector: calls all group modules and returns the merged highlight table.
-- Sets C, O, U globals so group modules can reference them without argument passing.
local M = {}

---Assemble the full highlight table from all group modules.
---@return table  Merged highlights ready for compilation.
function M.collect()
  -- Set globals for group modules to reference
  _G.C = require("chilling_potato.palette").get_palette()
  _G.O = require("chilling_potato").options
  _G.U = require("chilling_potato.palette")  -- utilities live in palette module

  C.none = "NONE"

  local highlights = {}

  -- Merge all group modules (order matters: later overrides earlier)
  local modules = { "editor", "treesitter", "lsp" }
  for _, mod in ipairs(modules) do
    local ok, result = pcall(require, "chilling_potato.groups." .. mod)
    if ok and result.get then
      highlights = vim.tbl_deep_extend("force", highlights, result.get())
    end
  end

  -- Apply user highlight overrides (last write wins)
  local overrides = O.highlight_overrides
  if overrides and type(overrides.all) == "table" then
    highlights = vim.tbl_deep_extend("force", highlights, overrides.all)
  end

  -- Clean up globals
  _G.C = nil
  _G.O = nil
  _G.U = nil

  return highlights
end

return M
