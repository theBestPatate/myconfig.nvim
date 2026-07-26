-- ty: Astral's Python type checker (LSP server)
-- https://github.com/astral-sh/ty
return {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
  settings = {
    ty = {},
  },
}
