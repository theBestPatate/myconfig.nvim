-- Treesitter @ groups: the core syntax highlighting
-- Uses the warm-grounded muted palette (v3) with 9 distinct accent hues.
-- Legacy groups (Function, String, Type, ...) auto-inherit via Neovim 0.10+ links.
local M = {}

function M.get()
  return {
    -- ══ Identifiers ═══════════════════════════════════
    ["@variable"]             = { fg = C.variable, style = O.styles.variables },
    ["@variable.builtin"]     = { fg = C.diag_error },  -- self, this, super
    ["@variable.parameter"]   = { fg = C.parameter, style = { "italic" } },
    ["@variable.member"]      = { fg = C.field, style = O.styles.properties },

    -- ══ Constants ══════════════════════════════════════
    ["@constant"]             = { fg = C.constant, style = O.styles.constants },
    ["@constant.builtin"]     = { fg = C.constant, style = O.styles.constants },
    ["@constant.macro"]       = { fg = C.constant, style = O.styles.constants },

    -- ══ Modules & labels ═══════════════════════════════
    ["@module"]               = { fg = C.type },
    ["@label"]                = { fg = C.type },

    -- ══ Literals ═══════════════════════════════════════
    ["@string"]                 = { fg = C.string, style = O.styles.strings },
    ["@string.documentation"]   = { fg = C.teal, style = O.styles.strings },
    ["@string.regexp"]          = { fg = C.operator },
    ["@string.escape"]          = { fg = C.operator, style = { "bold" } },
    ["@string.special"]         = { link = "@string" },
    ["@string.special.path"]    = { fg = C.field },
    ["@string.special.symbol"]  = { fg = C.constant },
    ["@string.special.url"]     = { fg = C.func, style = { "underline" } },
    ["@character"]              = { fg = C.string },
    ["@character.special"]      = { fg = C.operator },

    ["@boolean"]              = { fg = C.constant, style = O.styles.constants },
    ["@number"]               = { fg = C.number, style = O.styles.numbers },
    ["@number.float"]         = { link = "@number" },

    -- ══ Types ═══════════════════════════════════════════
    ["@type"]                 = { fg = C.type, style = O.styles.types },
    ["@type.builtin"]         = { fg = C.operator, style = O.styles.types },
    ["@type.definition"]      = { link = "@type" },
    ["@type.qualifier"]       = { link = "@keyword" },

    ["@attribute"]            = { fg = C.attribute, style = { "italic" } },
    ["@property"]             = { fg = C.field, style = O.styles.properties },

    -- ══ Functions ═══════════════════════════════════════
    ["@function"]               = { fg = C.func, style = O.styles.functions },
    ["@function.builtin"]       = { fg = C.func, style = O.styles.functions },
    ["@function.call"]          = { link = "@function" },
    ["@function.macro"]         = { fg = C.func, style = O.styles.functions },
    ["@function.method"]        = { link = "@function" },
    ["@function.method.call"]   = { link = "@function" },
    ["@constructor"]            = { fg = C.type, style = { "bold" } },

    -- ══ Keywords ════════════════════════════════════════
    ["@keyword"]                  = { fg = C.keyword, style = O.styles.keywords },
    ["@keyword.function"]         = { fg = C.keyword, style = O.styles.keywords },
    ["@keyword.operator"]         = { fg = C.keyword, style = O.styles.keywords },
    ["@keyword.return"]           = { fg = C.keyword, style = O.styles.keywords },
    ["@keyword.conditional"]      = { link = "@keyword" },
    ["@keyword.conditional.ternary"] = { link = "@operator" },
    ["@keyword.repeat"]           = { link = "@keyword" },
    ["@keyword.import"]           = { fg = C.keyword, style = O.styles.keywords },
    ["@keyword.exception"]        = { fg = C.keyword, style = O.styles.keywords },
    ["@keyword.coroutine"]        = { link = "@keyword" },
    ["@keyword.modifier"]         = { link = "@keyword" },
    ["@keyword.type"]             = { link = "@keyword" },
    ["@keyword.debug"]            = { link = "@keyword" },
    ["@keyword.directive"]        = { fg = C.keyword, style = O.styles.keywords },
    ["@keyword.directive.define"] = { link = "@keyword.directive" },
    ["@keyword.export"]           = { fg = C.keyword, style = O.styles.keywords },

    -- ══ Operators ═══════════════════════════════════════
    ["@operator"]             = { fg = C.operator, style = O.styles.operators },

    -- ══ Punctuation ═════════════════════════════════════
    ["@punctuation.delimiter"]        = { fg = C.fg_subtle },
    ["@punctuation.bracket"]          = { fg = C.fg_dim },
    ["@punctuation.special"]          = { fg = C.fg_subtle },
    ["@punctuation.delimiter.regex"]  = { link = "@string.regexp" },

    -- ══ Comments ════════════════════════════════════════
    ["@comment"]               = { fg = C.comment, style = O.styles.comments },
    ["@comment.documentation"] = { fg = C.fg_subtle, style = { "italic" } },
    ["@comment.error"]         = { fg = C.diag_error, style = { "bold" } },
    ["@comment.warning"]       = { fg = C.diag_warn, style = { "bold" } },
    ["@comment.todo"]          = { fg = C.gold, style = { "bold" } },
    ["@comment.note"]          = { fg = C.diag_info },
    ["@comment.hint"]          = { fg = C.fg_subtle },

    -- ══ Error ═══════════════════════════════════════════
    ["@error"]                 = { fg = C.diag_error },

    -- ══ Tags (HTML/JSX) ═════════════════════════════════
    ["@tag"]              = { fg = C.func },
    ["@tag.builtin"]      = { fg = C.func },
    ["@tag.attribute"]    = { fg = C.attribute },
    ["@tag.delimiter"]    = { fg = C.fg_subtle },

    -- ══ Markup ══════════════════════════════════════════
    ["@markup"]                = { fg = C.fg },
    ["@markup.strong"]         = { fg = C.gold, style = { "bold" } },
    ["@markup.italic"]         = { fg = C.teal, style = { "italic" } },
    ["@markup.strikethrough"]  = { fg = C.fg_dim, style = { "strikethrough" } },
    ["@markup.underline"]      = { fg = C.fg, style = { "underline" } },
    ["@markup.heading"]        = { fg = C.markup, style = { "bold" } },
    ["@markup.heading.markdown"] = { link = "@markup.heading" },
    ["@markup.math"]           = { fg = C.func },
    ["@markup.quote"]          = { fg = C.comment, style = { "italic" } },
    ["@markup.link"]           = { fg = C.field },
    ["@markup.link.label"]     = { fg = C.field },
    ["@markup.link.url"]       = { fg = C.func, style = { "underline" } },
    ["@markup.raw"]            = { fg = C.string },
    ["@markup.list"]           = { fg = C.func },
    ["@markup.list.checked"]   = { fg = C.diag_ok },
    ["@markup.list.unchecked"] = { fg = C.fg_dim },
    ["@markup.environment"]    = { fg = C.func },
    ["@markup.environment.name"] = { fg = C.type },

    -- ══ Diff ════════════════════════════════════════════
    ["@diff.plus"]             = { fg = C.diff_add },
    ["@diff.minus"]            = { fg = C.diff_delete },
    ["@diff.delta"]            = { fg = C.diff_change },

    -- ══ Language-specific overrides ═════════════════════
    -- Bash
    ["@function.builtin.bash"]   = { fg = C.diag_error, style = { "italic" } },
    ["@variable.parameter.bash"] = { fg = C.string },

    -- CSS
    ["@property.css"]       = { fg = C.func },
    ["@property.id.css"]    = { fg = C.type },
    ["@property.class.css"] = { fg = C.type },
    ["@type.css"]           = { fg = C.field },
    ["@type.tag.css"]       = { fg = C.func },

    -- HTML
    ["@string.special.url.html"]  = { fg = C.string },
    ["@markup.link.label.html"]   = { fg = C.fg },
    ["@character.special.html"]   = { fg = C.diag_error },

    -- Lua
    ["@constructor.lua"]    = { link = "@punctuation.bracket" },

    -- Markdown headings (spread across accent hues)
    ["@markup.heading.1.markdown"] = { fg = C.markup, style = { "bold" } },
    ["@markup.heading.2.markdown"] = { fg = C.func, style = { "bold" } },
    ["@markup.heading.3.markdown"] = { fg = C.type, style = { "bold" } },
    ["@markup.heading.4.markdown"] = { fg = C.field, style = { "bold" } },
    ["@markup.heading.5.markdown"] = { fg = C.operator, style = { "bold" } },
    ["@markup.heading.6.markdown"] = { fg = C.string, style = { "bold" } },

    -- YAML
    ["@label.yaml"]         = { fg = C.type },
  }
end

return M
