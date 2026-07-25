local now_if_args = Config.now_if_args

-- oil.nvim: directory-as-buffer file manager.
-- No leader keybindings — use fzf-lua (<Leader>ff) for navigation.
-- Open oil manually with :Oil or edit a directory path.
vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

now_if_args(function()
	require("oil").setup()
end)
