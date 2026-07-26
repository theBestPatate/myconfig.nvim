-- LSP diagnostics, semantic tokens, and reference highlights
local M = {}

function M.get()
  local vt = O.lsp_styles.virtual_text
  local ul = O.lsp_styles.underlines

  return {
    -- ══ Semantic tokens ═════════════════════════════════
    -- Most @lsp.type.* groups are auto-linked by Neovim.
    -- We only override where LSP provides better precision than Treesitter.
    ["@lsp.type.enumMember"]  = { fg = C.fg_mid },
    ["@lsp.type.variable"]    = {},  -- let Treesitter handle variables
    ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.function.builtin"]       = { link = "@function.builtin" },

    -- ══ LspReference (textDocument/references) ═════════
    LspReferenceText  = { bg = C.bg_light },
    LspReferenceRead  = { bg = C.bg_light },
    LspReferenceWrite = { bg = C.bg_light },

    -- ══ Diagnostic signs (gutter) ══════════════════════
    DiagnosticSignError = { fg = C.diag_error },
    DiagnosticSignWarn  = { fg = C.diag_warn },
    DiagnosticSignInfo  = { fg = C.diag_info },
    DiagnosticSignHint  = { fg = C.diag_hint },
    DiagnosticSignOk    = { fg = C.diag_ok },

    -- ══ Diagnostic virtual text ════════════════════════
    DiagnosticVirtualTextError = { fg = C.diag_error, style = vt.errors },
    DiagnosticVirtualTextWarn  = { fg = C.diag_warn, style = vt.warnings },
    DiagnosticVirtualTextInfo  = { fg = C.diag_info, style = vt.information },
    DiagnosticVirtualTextHint  = { fg = C.diag_hint, style = vt.hints },
    DiagnosticVirtualTextOk    = { fg = C.diag_ok, style = vt.information },

    -- ══ Diagnostic underlines ══════════════════════════
    DiagnosticUnderlineError = { sp = C.diag_error, style = ul.errors },
    DiagnosticUnderlineWarn  = { sp = C.diag_warn, style = ul.warnings },
    DiagnosticUnderlineInfo  = { sp = C.diag_info, style = ul.information },
    DiagnosticUnderlineHint  = { sp = C.diag_hint, style = ul.hints },
    DiagnosticUnderlineOk    = { sp = C.diag_ok, style = ul.ok },

    -- ══ Diagnostic floating messages ═══════════════════
    DiagnosticFloatingError = { fg = C.diag_error },
    DiagnosticFloatingWarn  = { fg = C.diag_warn },
    DiagnosticFloatingInfo  = { fg = C.diag_info },
    DiagnosticFloatingHint  = { fg = C.diag_hint },
    DiagnosticFloatingOk    = { fg = C.diag_ok },

    -- ══ Diagnostic base groups ═════════════════════════
    DiagnosticError = { fg = C.diag_error },
    DiagnosticWarn  = { fg = C.diag_warn },
    DiagnosticInfo  = { fg = C.diag_info },
    DiagnosticHint  = { fg = C.diag_hint },
    DiagnosticOk    = { fg = C.diag_ok },

    -- ══ Legacy LSP diagnostic names (for older plugins) ═
    LspDiagnosticsDefaultError             = { fg = C.diag_error },
    LspDiagnosticsDefaultWarning           = { fg = C.diag_warn },
    LspDiagnosticsDefaultInformation       = { fg = C.diag_info },
    LspDiagnosticsDefaultHint              = { fg = C.diag_hint },
    LspDiagnosticsError                    = { link = "DiagnosticError" },
    LspDiagnosticsWarning                  = { link = "DiagnosticWarn" },
    LspDiagnosticsInformation              = { link = "DiagnosticInfo" },
    LspDiagnosticsHint                     = { link = "DiagnosticHint" },
    LspDiagnosticsVirtualTextError         = { link = "DiagnosticVirtualTextError" },
    LspDiagnosticsVirtualTextWarning       = { link = "DiagnosticVirtualTextWarn" },
    LspDiagnosticsVirtualTextInformation   = { link = "DiagnosticVirtualTextInfo" },
    LspDiagnosticsVirtualTextHint          = { link = "DiagnosticVirtualTextHint" },
    LspDiagnosticsUnderlineError           = { link = "DiagnosticUnderlineError" },
    LspDiagnosticsUnderlineWarning         = { link = "DiagnosticUnderlineWarn" },
    LspDiagnosticsUnderlineInformation     = { link = "DiagnosticUnderlineInfo" },
    LspDiagnosticsUnderlineHint            = { link = "DiagnosticUnderlineHint" },
    LspDiagnosticsFloatingError            = { link = "DiagnosticFloatingError" },
    LspDiagnosticsFloatingWarning          = { link = "DiagnosticFloatingWarn" },
    LspDiagnosticsFloatingInformation      = { link = "DiagnosticFloatingInfo" },
    LspDiagnosticsFloatingHint             = { link = "DiagnosticFloatingHint" },

    -- ══ Other LSP features ═════════════════════════════
    LspSignatureActiveParameter = { bg = C.bg_light, style = { "bold" } },
    LspCodeLens                 = { fg = C.fg_dim },
    LspCodeLensSeparator        = { link = "LspCodeLens" },
    LspInlayHint                = { fg = C.fg_dim, bg = C.bg_light },
    LspInfoBorder               = { link = "FloatBorder" },
  }
end

return M
