-- Locate the project virtualenv and the ruff binary, shared by the ruff LSP
-- (after/lsp/ruff.lua) and conform (plugin/20_editor.lua) so both use the
-- SAME ruff version instead of drifting apart.
--
-- Order of preference: the project's own venv ruff (matches the version the
-- project pins / CI uses), otherwise whatever `ruff` resolves to on $PATH.

local M = {}

-- Walk up from `start` (default: cwd) looking for a project virtualenv.
function M.venv(start)
  start = start or vim.fn.getcwd()
  for _, name in ipairs { '.venv', 'venv' } do
    local dir = vim.fn.finddir(name, start .. ';')
    if dir ~= '' then
      -- Bail out if we climbed more than 10 levels
      local depth = #vim.fn.split(vim.fn.fnamemodify(dir, ':h'), '/')
      local base = #vim.fn.split(vim.fn.fnamemodify(start, ':p:h'), '/')
      if depth > base - 10 then
        return vim.fn.fnamemodify(dir, ':p')
      end
    end
  end
end

function M.python(start)
  local venv = M.venv(start)
  if venv then
    return venv .. 'bin/python'
  end
end

function M.bin(start)
  local venv = M.venv(start)
  if venv then
    local exe = venv .. 'bin/ruff'
    if vim.fn.executable(exe) == 1 then
      return exe
    end
  end
  local on_path = vim.fn.exepath 'ruff'
  return on_path ~= '' and on_path or 'ruff'
end

return M
