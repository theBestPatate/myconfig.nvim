local now, later = Config.now, Config.later

now(function()
	vim.pack.add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } })
end)

now(function()
	vim.pack.add({ { src = "https://github.com/folke/zen-mode.nvim", name = "zen-mode" } })
end)

now(function()
	vim.pack.add({ "https://github.com/theBestPatate/chilling_potato" })
end)

now(function()
	vim.cmd("colorscheme chilling-potato")
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
	-- Hide statusline and command line until needed
	vim.opt.laststatus = 0
	vim.opt.cmdheight = 0

	-- Floating window to show macro recording (since all bars are hidden)
	local rec_win = nil
	Config.new_autocmd("RecordingEnter", nil, function()
		local reg = vim.fn.reg_recording()
		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { " ● recording @" .. reg })
		rec_win = vim.api.nvim_open_win(buf, false, {
			relative = "win", row = 1, col = vim.api.nvim_win_get_width(0) - 16,
			width = 14, height = 1,
			style = "minimal",
			border = "rounded",
			noautocmd = true,
		})
		vim.api.nvim_set_hl(0, "MacroRecFloat", { fg = "#cca386", bg = "#252323", bold = true })
		vim.api.nvim_win_set_option(rec_win, "winhl", "Normal:MacroRecFloat,FloatBorder:MacroRecFloat")
	end, "Show macro recording floating window")
	Config.new_autocmd("RecordingLeave", nil, function()
		if rec_win and vim.api.nvim_win_is_valid(rec_win) then
			vim.api.nvim_win_close(rec_win, true)
		end
		rec_win = nil
	end, "Hide macro recording floating window")
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
	-- Visualize and work with indent scope (the animated vertical line)
	require("mini.indentscope").setup()
end)
