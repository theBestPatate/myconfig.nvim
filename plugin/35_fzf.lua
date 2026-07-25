local later = Config.later
local nmap_leader = function(suf, rhs, desc)
	vim.keymap.set("n", "<Leader>" .. suf, rhs, { desc = desc })
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
		fzf_opts = {
			["--preview-window"] = "right:60%:wrap",
		},
		defaults = {
			file_icons = true,
			git_icons = true,
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

	-- Live grep
	nmap_leader("fg", function()
		fzf.live_grep()
	end, "Grep")

	-- Grep word under cursor
	nmap_leader("fw", function()
		fzf.grep_cword()
	end, "Grep word")

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
		fzf.git_status()
	end, "Git status")
end)
