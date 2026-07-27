return {
	cmd = { vim.fn.stdpath("data") .. "/mason/bin/lua-language-server" },
	filetypes = { "lua" },

	-- Disable lua_ls built-in formatting — stylua LSP handles it instead
	on_init = function(client)
		if client.server_capabilities then
			client.server_capabilities.documentFormattingProvider = false
		end
	end,

	-- Explicitly define what constitutes a Lua project root
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local root_files = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", ".git" }
		on_dir(vim.fs.root(fname, root_files) or vim.fn.getcwd())
	end,
	on_attach = function(client, buf_id)
		local cp = client.server_capabilities.completionProvider
		if cp then
			cp.triggerCharacters = { ".", ":", "#", "(" }
		end
	end,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
			diagnostics = {
				globals = { "MiniBufremove", "MiniCompletion", "MiniDiff", "MiniIcons", "MiniKeymap", "MiniNotify" },
			},
			workspace = {
				checkThirdParty = false,
				ignoreSubmodules = true,
				library = { vim.env.VIMRUNTIME },
			},
			telemetry = { enable = false },
		},
	},
}
