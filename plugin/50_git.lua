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

	-- Mini Diff
	require("mini.diff").setup()

	-- Hunk navigation
	vim.keymap.set("n", "]h", function()
		if vim.wo.diff then return "]h" end
		vim.schedule(function() package.loaded.gitsigns.next_hunk() end)
		return "<Ignore>"
	end, { expr = true, desc = "Next git hunk" })
	vim.keymap.set("n", "[h", function()
		if vim.wo.diff then return "[h" end
		vim.schedule(function() package.loaded.gitsigns.prev_hunk() end)
		return "<Ignore>"
	end, { expr = true, desc = "Previous git hunk" })

	nmap_leader("go", "<Cmd>lua MiniDiff.toggle_overlay()<CR>", "Toggle overlay")
end)
