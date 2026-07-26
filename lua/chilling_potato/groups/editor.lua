-- Editor UI chrome: groups that have no @ equivalent
local M = {}

function M.get()
  return {
    -- ── Core text ──────────────────────────────────────
    Normal       = { fg = C.fg, bg = O.transparent and C.none or C.bg },
    NormalNC     = { fg = C.fg_dim, bg = O.transparent and C.none or C.bg },
    NormalFloat  = { fg = C.fg, bg = C.surface },
    FloatBorder  = { fg = C.fg_dim, bg = C.surface },
    FloatTitle   = { fg = C.fg_bright, bg = C.surface, style = { "bold" } },

    -- ── Cursor & selection ─────────────────────────────
    Cursor       = { fg = C.bg, bg = C.fg },
    CursorLine   = { bg = C.bg_light },
    CursorLineNr = { fg = C.fg_bright, style = { "bold" } },
    CursorColumn = { bg = C.bg_light },
    ColorColumn  = { bg = C.bg_light },
    Visual       = { bg = U.darken(C.fg_mid, 0.55, C.bg) },
    VisualNOS    = { link = "Visual" },

    -- ── Line numbers & signs ───────────────────────────
    LineNr       = { fg = C.fg_dim },
    LineNrAbove  = { fg = C.fg_dim },
    LineNrBelow  = { fg = C.fg_dim },
    SignColumn   = { fg = C.fg_dim, bg = O.transparent and C.none or C.bg },
    SignColumnSB = { fg = C.fg_dim, bg = C.bg },
    FoldColumn   = { fg = C.fg_dim },

    -- ── Statusline & tabline ───────────────────────────
    StatusLine   = { fg = C.fg, bg = C.surface },
    StatusLineNC = { fg = C.fg_dim, bg = C.surface },
    TabLine      = { bg = C.bg, fg = C.fg_dim },
    TabLineFill  = { bg = C.bg },
    TabLineSel   = { fg = C.fg, bg = C.bg_light },
    WinSeparator = { fg = C.fg_dim },
    WinBar       = { fg = C.fg_bright },
    WinBarNC     = { fg = C.fg_dim },

    -- ── Popup menu ─────────────────────────────────────
    Pmenu        = { fg = C.fg_dim, bg = C.surface },
    PmenuSel     = { fg = C.fg, bg = C.bg_light, style = { "bold" } },
    PmenuBorder  = { fg = C.fg_dim, bg = C.surface },
    PmenuSbar    = { bg = C.bg_light },
    PmenuThumb   = { bg = C.fg_dim },
    PmenuMatch   = { fg = C.fg, style = { "bold" } },
    PmenuMatchSel = { style = { "bold" } },
    PmenuExtra   = { fg = C.fg_dim },
    PmenuExtraSel = { fg = C.fg_dim, style = { "bold" } },

    -- ── Search ─────────────────────────────────────────
    Search       = { bg = U.darken(C.fg_mid, 0.40, C.bg), fg = C.fg },
    IncSearch    = { bg = U.lighten(C.surface, 0.30, C.fg_mid), fg = C.bg },
    CurSearch    = { bg = C.fg_mid, fg = C.bg, style = { "bold" } },
    Substitute   = { bg = C.fg_mid, fg = C.bg },
    MatchParen   = { fg = C.fg_bright, bg = C.bg_light, style = { "bold" } },

    -- ── Messages & prompts ─────────────────────────────
    ErrorMsg     = { fg = C.diag_error, style = { "bold" } },
    WarningMsg   = { fg = C.diag_warn, style = { "bold" } },
    ModeMsg      = { fg = C.fg, style = { "bold" } },
    MoreMsg      = { fg = C.diag_info },
    OkMsg        = { fg = C.diag_ok },
    Question     = { fg = C.diag_info },
    Title        = { fg = C.fg_bright, style = { "bold" } },
    WildMenu     = { bg = C.bg_light },

    -- ── Folds ──────────────────────────────────────────
    Folded       = { fg = C.fg_dim, bg = C.bg_light },

    -- ── Special characters ─────────────────────────────
    NonText      = { fg = C.fg_dim },
    EndOfBuffer  = { fg = C.bg },
    Whitespace   = { fg = C.fg_dim },
    SpecialKey   = { link = "NonText" },
    Conceal      = { fg = C.fg_dim },
    Directory    = { fg = C.func },

    -- ── Diffs ──────────────────────────────────────────
    DiffAdd      = { bg = U.darken(C.diff_add, 0.85, C.bg) },
    DiffChange   = { bg = U.darken(C.diff_change, 0.85, C.bg) },
    DiffDelete   = { bg = U.darken(C.diff_delete, 0.85, C.bg) },
    DiffText     = { bg = U.darken(C.diff_change, 0.70, C.bg) },
    Added        = { fg = C.diff_add },
    Changed      = { fg = C.diff_change },
    Removed      = { fg = C.diff_delete },
    diffAdded    = { fg = C.diff_add },
    diffRemoved  = { fg = C.diff_delete },
    diffChanged  = { fg = C.diff_change },

    -- ── Spell ──────────────────────────────────────────
    SpellBad     = { sp = C.diag_error, style = { "undercurl" } },
    SpellCap     = { sp = C.diag_warn, style = { "undercurl" } },
    SpellLocal   = { sp = C.diag_info, style = { "undercurl" } },
    SpellRare    = { sp = C.diag_ok, style = { "undercurl" } },

    -- ── Misc ───────────────────────────────────────────
    QuickFixLine = { bg = C.bg_light, style = { "bold" } },
    debugPC      = { bg = C.bg_light },
    debugBreakpoint = { bg = C.surface, fg = C.fg_dim },
    TermCursor   = { fg = C.bg, bg = C.fg },
    TermCursorNC = { fg = C.bg, bg = C.fg_dim },
  }
end

return M
