local function find_venv_python()
  local cwd = vim.fn.getcwd()
  for _, name in ipairs { '.venv', 'venv' } do
    local dir = vim.fn.finddir(name, cwd .. ';')
    if dir ~= '' then
      -- Bail out if we climbed more than 10 levels
      local depth = #vim.fn.split(vim.fn.fnamemodify(dir, ':h'), '/')
      local cwd_depth = #vim.fn.split(cwd, '/')
      if depth <= cwd_depth - 10 then
        return nil
      end
      return vim.fn.fnamemodify(dir, ':p') .. '/bin/python'
    end
  end
end

local cfg = {
  cmd = { vim.fn.stdpath 'data' .. '/mason/bin/ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
}

local python = find_venv_python()
if python then
  cfg.settings = { interpreter = { python } }
end

return cfg
