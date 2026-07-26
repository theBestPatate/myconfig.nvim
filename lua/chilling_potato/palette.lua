-- chilling-potato palette v4 — HSLuv-optimized, warm-grounded, coastal
--
-- All accent colors computed in the perceptually uniform HSLuv color space
-- for optimal hue spacing, controlled saturation, and luminance hierarchy.
--
-- Design principles:
--   1. Warm charcoal bg (H=30°) + warm cream fg (~82% L) — gentle on the eyes
--   2. 9 accent hues spread 14°–346°, with wider gaps between role groups
--   3. Keyword↔Function: 46° separation (most frequent adjacency in code)
--   4. Luminance hierarchy: markup(72) > type(70) > func(69) > constant(66) >
--      keyword(64) > field(63) > string(62) > number(60) > operator(56)
--   5. All accents at 22–38% saturation — muted enough to avoid chromatic aberration
--   6. "Coastal" metaphor: warm sand grounding + cool ocean accents + beach rose warmth

local M = {}

-- Reference endpoints for darken() / lighten()
M.bg_ref = "#1d1b1a"   -- warm charcoal (HSLuv: 30°, 5%, 10%)
M.fg_ref = "#d2cbc6"   -- warm cream (HSLuv: 42°, 10%, 82%)

---Return the full palette dictionary.
function M.get_palette()
  return {
    none = "NONE",

    -- ══ Backgrounds (warm charcoal family, H=30°) ═══════
    bg           = "#1d1b1a",  -- main background (L=10%)
    bg_light     = "#252323",  -- CursorLine, Visual, Folded (L=14%)
    surface      = "#2e2c2b",  -- StatusLine, Float bg, Pmenu (L=18%)
    surface_alt  = "#373433",  -- brighter surface variant (L=22%)

    -- ══ Foregrounds (cream family) ══════════════════════
    fg           = "#d2cbc6",  -- primary text: warm cream (L=82%, not glaring)
    fg_light     = "#dbd6d4",  -- slightly brighter (L=86%)
    fg_dim       = "#656871",  -- comments, line numbers, inactive UI (L=44%)
    fg_subtle    = "#8b8e98",  -- punctuation, delimiters (L=59%)
    fg_mid       = "#a9abb2",  -- intermediate (L=70%)
    fg_bright    = "#d3a88a",  -- gold: headings, UI highlights (L=72%)

    -- ══ Syntax accents (HSLuv-optimized, 22-38% saturation) ═

    -- Cool spectrum — the "chilling-potato" ──────────────────
    lavender    = "#9599bc",  -- H=262° S=32% L=64%  keywords
    periwinkle  = "#7787a2",  -- H=248° S=28% L=56%  operators (dimmer than keywords)
    sky         = "#8cb4c1",  -- H=216° S=40% L=71%  functions, methods
    seafoam     = "#839e9c",  -- H=188° S=28% L=63%  fields, properties
    sage        = "#85a781",  -- H=124° S=32% L=65%  strings
    teal        = "#839e9c",  -- alias → seafoam

    -- Warm spectrum — the "coastal warmth" ────────────────
    gold        = "#cca386",  -- H= 42° S=38% L=70%  types, constructors
    amber       = "#bc8373",  -- H= 26° S=36% L=60%  numbers, parameters
    terracotta  = "#c38a88",  -- H= 14° S=32% L=63%  attributes, decorators
    rose        = "#c294a5",  -- H=346° S=30% L=66%  constants, macros

    -- ══ Semantic aliases ════════════════════════════════

    -- Diagnostics
    diag_error  = "#c17f84",  -- coral (H=8° S=34% L=60%)
    diag_warn   = "#ba9077",  -- amber (H=38° S=38% L=63%)
    diag_info   = "#7f989b",  -- slate blue (H=202° S=28% L=61%)
    diag_hint   = "#828693",  -- gray-purple (H=255° S=10% L=56%)
    diag_ok     = "#839c86",  -- soft green (H=132° S=22% L=62%)

    -- Syntax roles (mapped to accent hues above)
    keyword     = "#9599bc",  -- lavender: "structure words"
    operator    = "#7787a2",  -- periwinkle: "syntax glue" — dimmer
    func        = "#8cb4c1",  -- sky blue: "where the action is"
    field       = "#839e9c",  -- seafoam: "member access"
    string      = "#85a781",  -- sage: "data content"
    type        = "#cca386",  -- gold: "type names" — warmest accent
    number      = "#bc8373",  -- amber: "literal values"
    attribute   = "#c38a88",  -- terracotta: "annotations"
    constant    = "#c294a5",  -- rose: "immutable values"
    parameter   = "#bc8373",  -- = amber: function parameters
    markup      = "#d3a88a",  -- = fg_bright gold: headings

    comment     = "#656871",  -- = fg_dim: recedes into background
    variable    = "#d2cbc6",  -- = fg: plain text

    -- ══ Diff / git ══════════════════════════════════════
    diff_add    = "#7f9782",  -- soft green (H=132° S=22% L=60%)
    diff_change = "#7d9598",  -- slate blue (H=202° S=28% L=60%)
    diff_delete = "#bf787d",  -- coral (H=8° S=34% L=58%)

    -- ══ Terminal colors ═════════════════════════════════
    term_black   = "#1d1b1a",
    term_red     = "#c17f84",
    term_green   = "#839c86",
    term_yellow  = "#cca386",
    term_blue    = "#8daeb8",
    term_magenta = "#c294a5",
    term_cyan    = "#839e9c",
    term_white   = "#d2cbc6",
  }
end

-- ══ Color utilities ════════════════════════════════════

local function hex_to_rgb(hex)
  hex = hex:lower()
  local r, g, b = hex:match("^#(%x%x)(%x%x)(%x%x)$")
  return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) }
end

---Blend fg onto bg with alpha (0 = pure bg, 1 = pure fg).
function M.blend(fg, bg, alpha)
  local f = hex_to_rgb(fg)
  local b = hex_to_rgb(bg)
  local c = function(i)
    return math.floor(math.min(math.max(0, alpha * f[i] + (1 - alpha) * b[i]), 255) + 0.5)
  end
  return string.format("#%02x%02x%02x", c(1), c(2), c(3))
end

---Darken hex toward M.bg_ref (or custom bg).
function M.darken(hex, amount, bg)
  return M.blend(hex, bg or M.bg_ref, 1 - math.abs(amount))
end

---Lighten hex toward M.fg_ref (or custom fg).
function M.lighten(hex, amount, fg)
  return M.blend(hex, fg or M.fg_ref, math.abs(amount))
end

return M
