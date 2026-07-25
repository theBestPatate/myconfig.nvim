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

	-- Ensure basic parsers are installed at startup
	local parsers = { "bash", "c", "diff", "html", "lua", "luadoc", "markdown", "markdown_inline", "query", "vim", "vimdoc" }
	local installed = require("nvim-treesitter").get_installed("parsers")
	local to_install = vim.tbl_filter(function(lang)
		return not vim.tbl_contains(installed, lang)
	end, parsers)
	if #to_install > 0 then
		require("nvim-treesitter").install(to_install)
	end

	-- Attach treesitter to a buffer with indent fallback
	---@param buf integer
	---@param language string
	local function treesitter_try_attach(buf, language)
		if not vim.treesitter.language.add(language) then return end
		vim.treesitter.start(buf, language)

		-- Only enable treesitter indent if the language has indent queries;
		-- otherwise fall back to Vim's built-in indentexpr
		local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil
		if has_indent_query then
			vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end

	-- Auto-attach treesitter for any filetype with a parser
	local available_parsers = require("nvim-treesitter").get_available()
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("custom-treesitter", {}),
		callback = function(args)
			local buf, filetype = args.buf, args.match
			local language = vim.treesitter.language.get_lang(filetype)
			if not language then return end

			local installed_parsers = require("nvim-treesitter").get_installed("parsers")
			if vim.tbl_contains(installed_parsers, language) then
				-- Parser already installed: attach immediately
				treesitter_try_attach(buf, language)
			elseif vim.tbl_contains(available_parsers, language) then
				-- Parser available but not installed: auto-install then attach
				require("nvim-treesitter").install(language):await(function()
					treesitter_try_attach(buf, language)
				end)
			else
				-- Parser not in nvim-treesitter (e.g. custom): try to attach anyway
				treesitter_try_attach(buf, language)
			end
		end,
	})
end)

-- 2. LSP Servers & Mason =====================================================
now_if_args(function()
	vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })
	vim.pack.add({ "https://github.com/mason-org/mason.nvim" })

	require("mason").setup()

	-- Server configs (merged with nvim-lspconfig defaults via vim.lsp.config)
	-- Custom configs are loaded from after/lsp/<name>.lua, defaults use {}
	local servers = {}
	for _, name in ipairs({
		"lua_ls",
		"stylua",
		"tinymist",
		"marksman",
		"vtsls",
		"oxlint",
		"superhtml",
		"ty",
	}) do
		local cfg = {}
		local cfg_file = vim.fn.stdpath("config") .. "/after/lsp/" .. name .. ".lua"
		if vim.uv.fs_stat(cfg_file) then
			cfg = dofile(cfg_file)
		end
		servers[name] = cfg
	end

	for name, cfg in pairs(servers) do
		vim.lsp.config(name, cfg)
		vim.lsp.enable(name)
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
