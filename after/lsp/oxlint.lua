return {
  cmd = { vim.fn.stdpath 'data' .. '/mason/bin/oxlint', 'lsp' },
  filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
}
