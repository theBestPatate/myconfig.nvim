local ruff = require 'local.ruff'

local cfg = {
  -- Resolved at client start (anchored on the project root) so the LSP and
  -- conform run the SAME ruff binary -- see lua/local/ruff.lua.
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start({ ruff.bin(config.root_dir), 'server' }, dispatchers, {
      cwd = config.cmd_cwd,
      env = config.cmd_env,
      detached = config.detached,
    })
  end,
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
}

local python = ruff.python()
if python then
  cfg.init_options = { settings = { interpreter = { python } } }
end

return cfg
