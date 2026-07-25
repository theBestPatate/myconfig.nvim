local later = Config.later
local nmap_leader = function(suf, rhs, desc)
	vim.keymap.set("n", "<Leader>" .. suf, rhs, { desc = desc })
end
local vmap_leader = function(suf, rhs, desc)
	vim.keymap.set("v", "<Leader>" .. suf, rhs, { desc = desc })
end

later(function()
	vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

	-- Explicit list of generated/cache directories to skip.
	-- We avoid relying on .gitignore because ~/.git exists and its
	-- rules leak into every project.
	local skip_dirs = {
		".git",
		"__pycache__",
		"node_modules",
		".venv",
		"venv",
		"dist",
		"build",
		"target",
		".cache",
		".mypy_cache",
		".pytest_cache",
		".tox",
		".eggs",
		"*.egg-info",
		".next",
		".nuxt",
		".svelte-kit",
		"coverage",
		".terraform",
		"vendor",
	}

	-- Build --exclude flags for fd
	local fd_exclude_args = ""
	for _, dir in ipairs(skip_dirs) do
		fd_exclude_args = fd_exclude_args .. " --exclude " .. dir
	end

	-- Build -g '!...' globs for rg (ripgrep) — the leading ! means "not"
	local rg_ignore_globs = {}
	for _, dir in ipairs(skip_dirs) do
		table.insert(rg_ignore_globs, "-g '!" .. dir .. "/**'")
	end

	require("fzf-lua").setup({
		defaults = {
			file_icons = true,
			git_icons = true,
		},
		winopts = {
			width = 0.90,
			height = 0.85,
			preview = {
				horizontal = "right:65%",
				title = true,
			},
		},
		keymap = {
			builtin = {
				true, -- inherit all defaults
				["<C-d>"] = "preview-page-down",
				["<C-u>"] = "preview-page-up",
				["<S-down>"] = false,
				["<S-up>"] = false,
				["<M-S-down>"] = false,
				["<M-S-up>"] = false,
			},
			fzf = {
				true, -- inherit all defaults
				["ctrl-d"] = "preview-page-down",
				["ctrl-u"] = "preview-page-up",
				["shift-down"] = false,
				["shift-up"] = false,
				["alt-shift-down"] = false,
				["alt-shift-up"] = false,
			},
		},
		files = {
			-- Use fd but ignore .gitignore — we use our own exclude list
			cmd = "fd --no-ignore-vcs --hidden --type f " .. fd_exclude_args,
		},
		grep = {
			-- Use rg but ignore .gitignore — we use our own glob excludes
			rg_opts = "--no-ignore --hidden --column --line-number " .. table.concat(rg_ignore_globs, " "),
		},
	})

	local fzf = require("fzf-lua")

	-- Files
	nmap_leader("ff", function()
		fzf.files({ cwd = vim.fn.getcwd() })
	end, "Files")

	---Save visual selection anchor, run fzf-lua, then extend the selection
	---to the cursor position when returning to the original buffer.
	---Replicates `/` behavior: start selection, search, jump, selection
	---automatically grows to include the match.
	---@param fzf_action function  fzf-lua action to run (e.g. fzf.live_grep)
	local function with_visual_restore(fzf_action)
		local start_pos = vim.fn.getpos("v")
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)

		local function restore_visual()
			vim.fn.setpos("'<", start_pos)
			vim.fn.setpos("'>", vim.fn.getpos("."))
			vim.cmd("normal! gv")
		end

		local orig_buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("fzf-visual", {}),
			callback = function(args)
				if args.buf == orig_buf then
					vim.api.nvim_del_augroup_by_name("fzf-visual")
					vim.schedule(restore_visual)
				end
			end,
		})

		fzf_action()
	end

	-- Live grep
	nmap_leader("fg", function()
		fzf.live_grep()
	end, "Grep")
	vmap_leader("fg", function()
		with_visual_restore(function() fzf.live_grep() end)
	end, "Grep")

	-- Grep word under cursor
	nmap_leader("fw", function()
		fzf.grep_cword()
	end, "Grep word")
	vmap_leader("fw", function()
		with_visual_restore(function() fzf.grep_visual() end)
	end, "Grep selection")

	-- Buffers
	nmap_leader("fb", function()
		fzf.buffers()
	end, "Buffers")

	-- Resume last search
	nmap_leader("fr", function()
		fzf.resume()
	end, "Resume")

	-- Help tags
	nmap_leader("fh", function()
		fzf.help_tags()
	end, "Help")

	-- Command palette
	nmap_leader("fc", function()
		fzf.commands()
	end, "Commands")

	-- Recent files (oldfiles)
	nmap_leader("fo", function()
		fzf.oldfiles()
	end, "Oldfiles")

	-- Git files
	nmap_leader("fG", function()
		fzf.git_files()
	end, "Git files")

	-- Git status
	nmap_leader("fs", function()
		fzf.git_status({
			actions = {
				["tab"]   = { fn = require("fzf-lua").actions.git_stage_unstage, reload = true },
				["left"]  = false,
				["right"] = false,
			},
		})
	end, "Git status")
end)
