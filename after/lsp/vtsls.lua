return {
  cmd = { vim.fn.stdpath 'data' .. '/mason/bin/vtsls', '--stdio' },
  filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
}
