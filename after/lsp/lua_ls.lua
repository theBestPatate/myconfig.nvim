return {
	-- Explicitly define what constitutes a Lua project root
	root_dir = function(fname)
		local lspconfig_util = require("lspconfig.util")
		return lspconfig_util.root_pattern(".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", ".git")(fname)
			or vim.fn.getcwd()
	end,
	on_attach = function(client, buf_id)
		client.server_capabilities.completionProvider.triggerCharacters = { ".", ":", "#", "(" }
	end,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
			workspace = {
				checkThirdParty = false,
				ignoreSubmodules = true,
				library = { vim.env.VIMRUNTIME },
			},
			telemetry = { enable = false },
		},
	},
}
