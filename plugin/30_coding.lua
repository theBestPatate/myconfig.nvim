local now_if_args, later = Config.now_if_args, Config.later

-- 1. Treesitter ==============================================================
now_if_args(function()
	Config.on_packchanged("nvim-treesitter", { "update" }, function()
		vim.cmd("TSUpdate")
	end, ":TSUpdate")

	vim.pack.add({
		"https://github.com/nvim-treesitter/nvim-treesitter",
		"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	})

	local languages = { "lua", "vimdoc", "markdown", "python", "rust", "html", "css", "javascript", "typescript" }
	local to_install = vim.tbl_filter(function(lang)
		return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
	end, languages)
	if #to_install > 0 then
		require("nvim-treesitter").install(to_install)
	end

	local filetypes = {}
	for _, lang in ipairs(languages) do
		for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
			table.insert(filetypes, ft)
		end
	end
	Config.new_autocmd("FileType", filetypes, function(ev)
		vim.treesitter.start(ev.buf)
	end, "Start tree-sitter")
end)

-- 2. LSP Servers & Mason =====================================================
now_if_args(function()
	vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })
	vim.pack.add({ "https://github.com/mason-org/mason.nvim" })

	require("mason").setup()

	-- Native Neovim 0.12: Enable servers.
	-- This automatically reads configuration from `after/lsp/<server>.lua`
	local servers = {
		"lua_ls",
		"tinymist",
		"marksman",
		"vtsls",
		"oxlint",
		"superhtml",
		"ty",
	}

	for _, lsp in ipairs(servers) do
		vim.lsp.enable(lsp)
	end

	-- LSP Keymaps
	local nmap_leader = function(suf, rhs, desc)
		vim.keymap.set("n", "<Leader>" .. suf, rhs, { desc = desc })
	end
	nmap_leader("la", "<Cmd>lua vim.lsp.buf.code_action()<CR>", "Actions")
	nmap_leader("ld", "<Cmd>lua vim.diagnostic.open_float()<CR>", "Diagnostic popup")
	nmap_leader("li", "<Cmd>lua vim.lsp.buf.implementation()<CR>", "Implementation")
	nmap_leader("lh", "<Cmd>lua vim.lsp.buf.hover()<CR>", "Hover")
	nmap_leader("lr", "<Cmd>lua vim.lsp.buf.rename()<CR>", "Rename")
	nmap_leader("lR", "<Cmd>lua vim.lsp.buf.references()<CR>", "References")
	nmap_leader("ls", "<Cmd>lua vim.lsp.buf.definition()<CR>", "Source definition")
end)

-- 3. Autocompletion & Snippets ===============================================
now_if_args(function()
	vim.pack.add({ "https://github.com/rafamadriz/friendly-snippets" })

	require("mini.completion").setup({
		lsp_completion = {
			source_func = "omnifunc",
			auto_setup = false,
			process_items = function(items, base)
				return MiniCompletion.default_process_items(
					items,
					base,
					{ kind_priority = { Text = -1, Snippet = 99 } }
				)
			end,
		},
	})

	Config.new_autocmd("LspAttach", nil, function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
	end, "Set 'omnifunc'")

	-- Globally inject mini.completion capabilities into all LSP servers
	vim.lsp.config("*", { capabilities = MiniCompletion.get_lsp_capabilities() })

	local snippets = require("mini.snippets")
	snippets.setup({
		snippets = {
			snippets.gen_loader.from_file(vim.fn.stdpath("config") .. "/snippets/global.json"),
			snippets.gen_loader.from_lang({ lang_patterns = { tex = { "latex/**/*.json" } } }),
		},
	})
end)

now_if_args(function()
	vim.pack.add({ "https://github.com/esmuellert/codediff.nvim" })
end)
