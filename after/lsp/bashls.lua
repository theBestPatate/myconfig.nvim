return {
  cmd = { vim.fn.stdpath 'data' .. '/mason/bin/bash-language-server', 'start' },
  filetypes = { 'sh', 'bash', 'zsh' },
}
