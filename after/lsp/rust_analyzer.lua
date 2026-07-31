return {
  cmd = { vim.fn.stdpath 'data' .. '/mason/bin/rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', '.git' },
}
