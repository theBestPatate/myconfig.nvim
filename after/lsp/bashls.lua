return {
  cmd = { vim.fn.stdpath 'data' .. '/mason/bin/bash-language-server', 'start' },
  filetypes = { 'sh', 'bash', 'zsh' },
  root_dir = function(fname)
    return vim.fs.root(fname, { '.git' }) or vim.fn.getcwd()
  end,
}
