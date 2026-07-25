local now, later = Config.now, Config.later

-- 1. Text manipulation (Mini tools)
later(function()
	require("mini.pairs").setup({ modes = { command = true } })
	require("mini.comment").setup()
	require("mini.move").setup()
	require("mini.splitjoin").setup()
	require("mini.align").setup()
	require("mini.trailspace").setup()
	require("mini.operators").setup()

	-- Autocompletion menu & Auto-pairs navigation
	require("mini.keymap").setup()
	MiniKeymap.map_multistep("i", "<Tab>", { "pmenu_next" })
	MiniKeymap.map_multistep("i", "<S-Tab>", { "pmenu_prev" })
	MiniKeymap.map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
	MiniKeymap.map_multistep("i", "<BS>", { "minipairs_bs" })

	-- Swap arguments left/right (via treesitter-textobjects swap)
	-- Must be inside a treesitter-enabled buffer to work
	vim.keymap.set("n", "(", function()
		local ok, swap = pcall(require, "nvim-treesitter-textobjects.swap")
		if ok then swap.swap_previous("@parameter.inner") end
	end, { desc = "Swap arg left" })
	vim.keymap.set("n", ")", function()
		local ok, swap = pcall(require, "nvim-treesitter-textobjects.swap")
		if ok then swap.swap_next("@parameter.inner") end
	end, { desc = "Swap arg right" })
end)

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		-- require and setup only when filetype is set
		local ok, ts_textobjects = pcall(require, "nvim-treesitter-textobjects")

		if not ok then
			return
		end

		ts_textobjects.setup({
			select = { lookahead = true, selection_modes = { ["@function.outer"] = "V", ["@class.outer"] = "V" } },

			move = { set_jumps = true },
		})

		local select = require("nvim-treesitter-textobjects.select")

		local move = require("nvim-treesitter-textobjects.move")

		local swap = require("nvim-treesitter-textobjects.swap")

		local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

		local function sel(key, capture)
			vim.keymap.set({ "x", "o" }, key, function()
				select.select_textobject(capture, "textobjects")
			end, { desc = "Select " .. capture, buffer = true })
		end

		-- selections (use buffer-local mappings)
		sel("af", "@function.outer")
		sel("if", "@function.inner")

		sel("ac", "@class.outer")
		sel("ic", "@class.inner")
		sel("aa", "@parameter.outer")
		sel("ia", "@parameter.inner")
		sel("ai", "@conditional.outer")
		sel("ii", "@conditional.inner")
		sel("al", "@loop.outer")
		sel("il", "@loop.inner")
		sel("ab", "@block.outer")
		sel("ib", "@block.inner")
		sel("aA", "@call.outer")
		sel("iA", "@call.inner")
		vim.keymap.set({ "x", "o" }, "as", function()
			select.select_textobject("@local.scope", "locals")
		end, { desc = "Select scope", buffer = true })

		-- moves (buffer-local)
		local function map(modes, lhs, fn, desc)
			vim.keymap.set(modes, lhs, fn, { desc = desc, buffer = true })
		end

		map({ "n", "x", "o" }, "]m", function()
			move.goto_next_start("@function.outer", "textobjects")
		end, "Next function start")
		map({ "n", "x", "o" }, "]M", function()
			move.goto_next_end("@function.outer", "textobjects")
		end, "Next function end")
		map({ "n", "x", "o" }, "[m", function()
			move.goto_previous_start("@function.outer", "textobjects")
		end, "Prev function start")
		map({ "n", "x", "o" }, "[M", function()
			move.goto_previous_end("@function.outer", "textobjects")
		end, "Prev function end")

		map({ "n", "x", "o" }, "]]", function()
			move.goto_next_start("@class.outer", "textobjects")
		end, "Next class start")
		map({ "n", "x", "o" }, "][", function()
			move.goto_next_end("@class.outer", "textobjects")
		end, "Next class end")
		map({ "n", "x", "o" }, "[[", function()
			move.goto_previous_start("@class.outer", "textobjects")
		end, "Prev class start")

		map({ "n", "x", "o" }, "[]", function()
			move.goto_previous_end("@class.outer", "textobjects")
		end, "Prev class end")

		map({ "n", "x", "o" }, "]o", function()
			move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
		end, "Next loop")
		map({ "n", "x", "o" }, "[o", function()
			move.goto_previous_start({ "@loop.inner", "@loop.outer" }, "textobjects")
		end, "Prev loop")
		map({ "n", "x", "o" }, "]i", function()
			move.goto_next("@conditional.outer", "textobjects")
		end, "Next conditional")
		map({ "n", "x", "o" }, "[i", function()
			move.goto_previous("@conditional.outer", "textobjects")
		end, "Prev conditional")

		vim.keymap.set("n", "<leader>a", function()
			swap.swap_next("@parameter.inner")
		end, { desc = "Swap param next", buffer = true })
		vim.keymap.set("n", "<leader>A", function()
			swap.swap_previous("@parameter.inner")
		end, { desc = "Swap param prev", buffer = true })

		map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, "Repeat move forward")
		map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous, "Repeat move backward")
		vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true, buffer = true })
		vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true, buffer = true })
		vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true, buffer = true })
		vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true, buffer = true })
	end,
})

-- 2. Flash.nvim (Priority over 's')
later(function()
	vim.pack.add({ "https://github.com/folke/flash.nvim" })
	require("flash").setup({})

	local map = vim.keymap.set
	map({ "n", "x", "o" }, "<leader>s", function()
		require("flash").jump()
	end, { desc = "Flash Jump" })
	map({ "n", "x", "o" }, "<leader>S", function()
		require("flash").treesitter_search()
	end, { desc = "Treesitter Search" })
	map("o", "r", function()
		require("flash").remote()
	end, { desc = "Remote Flash" })
end)

-- 3. Conform.nvim (Autoformatter)
later(function()
	vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

	require("conform").setup({
		notify_on_error = false,
		default_format_opts = {
			lsp_format = "fallback",
		},
		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			local disable_filetypes = { c = false, cpp = false }
			return { timeout_ms = 500, lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype] }
		end,
		formatters_by_ft = {
			python = { "black", "isort" },
			html = { "prettierd" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			javascriptreact = { "prettierd" },
			css = { "prettierd" },
		},
	})

	-- Conform Commands
	vim.api.nvim_create_user_command("ConformDisable", function(args)
		if args.bang then
			vim.b.disable_autoformat = true
		else
			vim.g.disable_autoformat = true
		end
	end, { desc = "Disable autoformat-on-save", bang = true })

	vim.api.nvim_create_user_command("ConformEnable", function()
		vim.b.disable_autoformat = false
		vim.g.disable_autoformat = false
	end, { desc = "Re-enable autoformat-on-save" })

	-- Conform Keymaps (Using 'c' for code to avoid 't' terminal conflict)
	vim.keymap.set("n", "<leader>cf", function()
		if vim.b.disable_autoformat then
			vim.cmd("ConformEnable")
			vim.notify("Enabled autoformat for current buffer")
		else
			vim.cmd("ConformDisable!")
			vim.notify("Disabled autoformat for current buffer")
		end
	end, { desc = "Toggle autoformat for current buffer" })

	vim.keymap.set("n", "<leader>cF", function()
		if vim.g.disable_autoformat then
			vim.cmd("ConformEnable")
			vim.notify("Enabled autoformat globally")
		else
			vim.cmd("ConformDisable")
			vim.notify("Disabled autoformat globally")
		end
	end, { desc = "Toggle autoformat globally" })
end)

-- 4. Nvim-surround
later(function()
	vim.pack.add({ "https://github.com/kylechui/nvim-surround" })
end)

-- 5. Vim-Slime (LEGACY)
-- later(function()
-- 	vim.pack.add({ "https://github.com/jpalardy/vim-slime" })
-- 	vim.g.slime_target = "neovim"
-- end)
