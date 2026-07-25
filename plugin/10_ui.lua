local now, later = Config.now, Config.later

now(function()
	vim.pack.add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } })
end)

now(function()
	vim.pack.add({ { src = "https://github.com/folke/zen-mode.nvim", name = "zen-mode" } })
end)

now(function()
	vim.cmd("colorscheme catppuccin-macchiato")
end)

now(function()
	require("mini.basics").setup({
		options = { basic = false },
		mappings = { windows = true, move_with_alt = true },
	})
end)

now(function()
	require("mini.icons").setup({
		use_file_extension = function(ext, _)
			local ext3 = { scm = true, txt = true, yml = true }
			local ext4 = { json = true, yaml = true }
			return not (ext3[ext:sub(-3)] or ext4[ext:sub(-4)])
		end,
	})
	later(MiniIcons.mock_nvim_web_devicons)
	later(MiniIcons.tweak_lsp_kind)
end)

now(function()
	require("mini.notify").setup()
end)
now(function()
	require("mini.statusline").setup()
end)
now(function()
	require("mini.tabline").setup()
end)

later(function()
	local miniclue = require("mini.clue")
	miniclue.setup({
		clues = {
			Config.leader_group_clues,
			miniclue.gen_clues.builtin_completion(),
			miniclue.gen_clues.g(),
			miniclue.gen_clues.marks(),
			miniclue.gen_clues.registers(),
			miniclue.gen_clues.square_brackets(),
			miniclue.gen_clues.windows({ submode_resize = true }),
			miniclue.gen_clues.z(),
		},
		triggers = {
			{ mode = { "n", "x" }, keys = "<Leader>" },
			{ mode = "n", keys = "\\" },
			{ mode = { "n", "x" }, keys = "[" },
			{ mode = { "n", "x" }, keys = "]" },
			{ mode = "i", keys = "<C-x>" },
			{ mode = { "n", "x" }, keys = "g" },
			{ mode = { "n", "x" }, keys = "'" },
			{ mode = { "n", "x" }, keys = "`" },
			{ mode = { "n", "x" }, keys = '"' },
			{ mode = { "i", "c" }, keys = "<C-r>" },
			{ mode = "n", keys = "<C-w>" },
			{ mode = { "n", "x" }, keys = "z" },
		},
	})
end)
later(function()
	-- nvim-treesitter-context: Show current code context at the top
	vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter-context" })
	require("treesitter-context").setup()

	-- Visualize and work with indent scope (the animated vertical line)
	require("mini.indentscope").setup()
end)
