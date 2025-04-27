return {
  -- NOTE: All git commands directly from neovim
  { 'tpope/vim-fugitive', enabled = true },
  {
    -- NOTE: show indent lines
    'lukas-reineke/indent-blankline.nvim',
    enabled = true,
    main = 'ibl',
    opts = {
      indent = { char = '│' },
    },
  },
  { 'jpalardy/vim-slime', enabled = true },
}
