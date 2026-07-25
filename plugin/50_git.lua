local later = Config.later
local nmap_leader = function(suf, rhs, desc)
	vim.keymap.set("n", "<Leader>" .. suf, rhs, { desc = desc })
end

later(function()
	-- Gitsigns (from your requested merge)
	vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })
	require("gitsigns").setup({
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
	})

	-- Mini Git / Diff
	require("mini.git").setup()
	require("mini.diff").setup()

	nmap_leader("ga", "<Cmd>Git diff --cached<CR>", "Added diff")
	nmap_leader("gc", "<Cmd>Git commit<CR>", "Commit")
	nmap_leader("gd", "<Cmd>Git diff<CR>", "Diff")
	nmap_leader("go", "<Cmd>lua MiniDiff.toggle_overlay()<CR>", "Toggle overlay")
	nmap_leader("gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", "Show at cursor")
end)
