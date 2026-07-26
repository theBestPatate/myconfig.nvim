-- chilling-potato: a monochrome-blue dark Neovim colorscheme
-- Modern-only: Treesitter @ groups + LSP. No legacy Vim syntax groups.
local M = {}

M.default_options = {
  transparent = false,
  -- Per-category style overrides (mirrors Catppuccin's API)
  styles = {
    comments    = { "italic" },
    keywords    = { "bold" },
    functions   = {},
    strings     = {},
    variables   = {},
    numbers     = {},
    constants   = {},
    types       = { "bold" },
    operators   = {},
    properties  = {},
  },
  -- LSP diagnostic styles
  lsp_styles = {
    virtual_text = {
      errors      = { "italic" },
      warnings    = { "italic" },
      information = { "italic" },
      hints       = { "italic" },
      ok          = { "italic" },
    },
    underlines = {
      errors      = { "undercurl" },
      warnings    = { "underdashed" },
      information = { "underdotted" },
      hints       = { "underdotted" },
      ok          = {},  -- no underline for ok diagnostics
    },
  },
  -- User-provided highlight group overrides (merged last)
  highlight_overrides = {},
  -- Compile cache path
  compile_path = vim.fn.stdpath("cache") .. "/chilling-potato",
}

M.options = vim.deepcopy(M.default_options)
M.path_sep = jit and (jit.os == "Windows" and "\\" or "/") or package.config:sub(1, 1)

-- ── Setup ──────────────────────────────────────────────

local did_setup = false

---Configure the theme before loading. Call once before colorscheme.
---@param user_conf table?  Partial options to merge over defaults.
function M.setup(user_conf)
  did_setup = true
  user_conf = user_conf or {}
  M.options = vim.tbl_deep_extend("keep", user_conf, M.default_options)

  -- Resolve highlight_overrides.all shorthand
  M.options.highlight_overrides.all = user_conf.custom_highlights
    or M.options.highlight_overrides.all

  -- Check cache validity
  local cached_path = M.options.compile_path .. M.path_sep .. "cached"
  local file = io.open(cached_path)
  local cached = nil
  if file then
    cached = file:read()
    file:close()
  end

  -- Simple hash: serialized config + Neovim version
  local hash = vim.inspect(user_conf) .. vim.fn.has("nvim-0.12")
  if cached ~= hash then
    M.compile()
    file = io.open(cached_path, "wb")
    if file then
      file:write(hash)
      file:close()
    end
  end
end

-- ── Load ───────────────────────────────────────────────

function M.load()
  if not did_setup then
    M.setup()
  end

  local compiled_path = M.options.compile_path .. M.path_sep .. "chilling-potato"
  local f = loadfile(compiled_path)
  if not f then
    M.compile()
    f = assert(loadfile(compiled_path), "chilling-potato: could not load compiled cache")
  end
  f()
end

-- ── Compile ────────────────────────────────────────────

function M.compile()
  require("chilling_potato.lib.compiler").compile()
end

-- ── User command ───────────────────────────────────────

vim.api.nvim_create_user_command("ChillingPotatoCompile", function()
  for name, _ in pairs(package.loaded) do
    if name:match("^chilling_potato") then
      package.loaded[name] = nil
    end
  end
  M.compile()
  vim.notify("chilling-potato: recompiled cache!", vim.log.levels.INFO)
  vim.cmd.colorscheme("chilling-potato")
end, {})

return M
