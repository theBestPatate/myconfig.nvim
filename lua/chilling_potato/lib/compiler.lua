-- Bytecode compiler: serializes the highlight table into compiled Lua bytecode.
-- Adapted from Catppuccin's compiler.
local M = {}

local fmt = string.format

---Serialize a Lua value for code generation.
local function inspect(t)
  if type(t) == "string" then
    return fmt("%q", t)
  elseif type(t) == "table" then
    local list = {}
    for k, v in pairs(t) do
      local tv = type(v)
      if tv == "string" then
        table.insert(list, fmt('[%s] = "%s"', type(k) == "number" and k or fmt("%q", k), v))
      elseif tv == "table" then
        table.insert(list, fmt("[%s] = %s", type(k) == "number" and k or fmt("%q", k), inspect(v)))
      elseif tv == "boolean" then
        if v then
          table.insert(list, fmt("[%s] = true", type(k) == "number" and k or fmt("%q", k)))
        end
      elseif tv == "number" then
        table.insert(list, fmt("[%s] = %s", type(k) == "number" and k or fmt("%q", k), tostring(v)))
      end
    end
    return fmt("{ %s }", table.concat(list, ", "))
  else
    return tostring(t)
  end
end

---Compile the full highlight table to bytecode and cache it.
function M.compile()
  local O = require("chilling_potato").options
  local path_sep = require("chilling_potato").path_sep

  local highlights = require("chilling_potato.groups").collect()

  local lines = {
    [[return string.dump(function()]],
    [[vim.o.termguicolors = true]],
    [[if vim.g.colors_name then vim.cmd("hi clear") end]],
    [[vim.g.colors_name = "chilling-potato"]],
    [[vim.o.background = "dark"]],
    [[local h = vim.api.nvim_set_hl]],
  }

  -- Flatten style arrays into boolean keys for nvim_set_hl
  -- e.g. style = { "bold", "italic" } → bold = true, italic = true
  for group, color in pairs(highlights) do
    if color.style then
      -- Respect no_italic / no_bold if those options existed (reserved for future)
      for _, style in ipairs(color.style) do
        color[style] = true
      end
      color.style = nil
    end
    if color.link then
      table.insert(lines, fmt([[h(0, "%s", { link = "%s" })]], group, color.link))
    else
      table.insert(lines, fmt([[h(0, "%s", %s)]], group, inspect(color)))
    end
  end

  table.insert(lines, "end, true)")

  -- Ensure compile directory exists
  if vim.fn.isdirectory(O.compile_path) == 0 then
    vim.fn.mkdir(O.compile_path, "p")
  end

  -- Compile to bytecode
  local compiled_path = O.compile_path .. path_sep .. "chilling-potato"
  local source = table.concat(lines, "\n")
  local f, err = loadstring(source)
  if not f then
    vim.notify("chilling-potato: compilation error:\n" .. err, vim.log.levels.ERROR)
    -- Write source for debugging
    local debug_path = O.compile_path .. path_sep .. "chilling-potato.lua"
    local dbg = io.open(debug_path, "w")
    if dbg then
      dbg:write(source)
      dbg:close()
    end
    return
  end

  local bytecode = f()
  local file = io.open(compiled_path, "wb")
  if file then
    file:write(bytecode)
    file:close()
  end
end

return M
