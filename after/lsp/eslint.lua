return {
  cmd = { vim.fn.stdpath 'data' .. '/mason/bin/eslint-lsp', '--stdio' },
  filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
}
