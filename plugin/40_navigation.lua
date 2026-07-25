local now_if_args, later = Config.now_if_args, Config.later
local nmap_leader = function(suf, rhs, desc)
	vim.keymap.set("n", "<Leader>" .. suf, rhs, { desc = desc })
end

vim.pack.add({
	"https://github.com/stevearc/oil.nvim",
})
now_if_args(function()
	require("oil").setup()
	--
	nmap_leader("ed", "<Cmd>Oil<CR>", "Directory")
	nmap_leader("eD", "<Cmd>Oil ..", "Directory above")
end)
