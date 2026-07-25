# Coding — LSP, Completion, Formatting

> **Important**: LSP features need a proper `.lua` file. Open the companion
> sample files in `demos/examples/` to follow along:
> - `demos/examples/lsp_demo.lua` — LSP hover, definition, references, rename
> - `demos/examples/args_demo.lua` — argument swapping
>
> This document explains the features; the `.lua` files let you try them live.
> Press `<Space>` — mini.clue shows `<Leader>l` = `+Language` and `<Leader>c` = `+Code`.

---

## 1. LSP — Language Server Protocol

Your config comes with `lua_ls` (Lua), `tinymist` (Typst), `marksman` (Markdown),
`vtsls` (TypeScript), and more — all auto-installed by Mason.

### `<Leader>lh` — Hover

Shows type information, documentation, and function signatures for whatever
is under the cursor.

**Try it**: Open `demos/examples/lsp_demo.lua`, place cursor on `setup`,
press `<Leader>lh`. You'll see: `function M.setup(opts: table|nil)`.

<!--DEMO
{
  "steps": [
    {"desc": "Open sample file", "keys": ":e demos/examples/lsp_demo.lua<CR>", "pause": 1.5},
    {"desc": "Hover on 'setup'", "keys": "/setup<CR>n<Leader>lh", "pause": 3.0},
    {"desc": "Close hover", "keys": "<Esc>", "pause": 1.0}
  ]
}
-->

### `<Leader>ls` — Go to Definition

Jump to where the symbol under cursor is defined. Works across files.

**Try it**: In `lsp_demo.lua`, place cursor on `deepcopy`, press `<Leader>ls`.
You'll jump to the Lua standard library definition.

### `<Leader>lR` — Find References

Find every location that references the symbol under cursor.

**Try it**: In `lsp_demo.lua`, place cursor on `M.options`, press `<Leader>lR`.
A quickfix list shows every read/write of that field.

### `<Leader>lr` — Rename

Rename a symbol across the entire project. All references update automatically.

**Try it**: In `lsp_demo.lua`, place cursor on `defaults`, press `<Leader>lr`,
type `cfg`. Every reference to `defaults` updates in every file.

### `<Leader>la` — Code Actions

Context-aware actions: extract function, auto-import, fix diagnostics, etc.

**Try it**: Place cursor on any variable, press `<Leader>la`. If there are
available actions (like "extract to variable"), they'll appear.

### `<Leader>ld` — Diagnostic Popup

Shows the full diagnostic message for the error/warning under cursor.

### `<Leader>li` — Go to Implementation

Jump to the implementation of an interface or abstract method.
Less used in Lua, but essential in TypeScript/Java/etc.

---

## 2. Completion — `<Tab>` / `<S-Tab>` / `<CR>`

Completion triggers automatically as you type. Uses `mini.completion`
with LSP as the source.

| Key | Context | Action |
|-----|---------|--------|
| `<Tab>` | Completion menu open | Select next item |
| `<S-Tab>` | Completion menu open | Select previous item |
| `<CR>` | Completion menu open | Accept selected item |
| `<BS>` | After auto-pair | Delete paired bracket/quote |

**Try it**: In `lsp_demo.lua`, go to the end of the file and type `M.` —
the completion menu appears with all fields of `M`. Use `<Tab>` / `<S-Tab>`
to browse, `<CR>` to select.

---

## 3. Snippets — `mini.snippets`

Pre-defined code templates from `friendly-snippets`. Expand a snippet
by typing its trigger and pressing `<Tab>`.

**Try it**: In a Lua file, type `fun` then `<Tab>` — it expands into a full
function template with tab-stops for the name and body.

```lua
-- Type 'fun' below and press <Tab>:
```

<!--DEMO
{
  "steps": [
    {"desc": "Type 'fun' and press Tab to expand snippet", "keys": "ofun<Tab>", "pause": 2.0},
    {"desc": "Cancel", "keys": "<Esc>u", "pause": 1.0}
  ]
}
-->

---

## 4. Autoformatting — conform.nvim

Formatting runs automatically on save. Conform uses the configured formatters
per filetype: `stylua` (Lua, via LSP), `black` + `isort` (Python), `prettierd` (web).

### `<Leader>cf` / `<Leader>cF` — Toggle Formatting

| Key | Scope |
|-----|-------|
| `<Leader>cf` | Toggle autoformat for **current buffer** |
| `<Leader>cF` | Toggle autoformat **globally** |

**Try it**: Press `<Leader>cf` to disable formatting in this buffer.
Make some messy indentation, save — it stays. Press `<Leader>cf` again
to re-enable, save — it snaps back.

### Disable by default for a filetype

```lua
-- In your config:
-- local disable_filetypes = { c = true, cpp = true }
```

---

## 5. Arguments Swap — `(` / `)`

Swap the argument under cursor with the next or previous one. Works anywhere
inside a function call or definition — cursor just needs to be on a parameter.

| Key | Action |
|-----|--------|
| `)` | Swap with next argument (right) |
| `(` | Swap with previous argument (left) |

**How it works**: Uses treesitter to identify the parameter node under cursor,
then swaps it with the adjacent one. Stays in normal mode — no insert mode
involved.

**Try it**: Open `demos/examples/args_demo.lua`, place cursor on `"localhost"`,
press `)` — it swaps with `5432`. Press `(` to swap back.

<!--DEMO
{
  "steps": [
    {"desc": "Swap arg right: 'localhost' ↔ 5432", "keys": "/localhost<CR>)", "pause": 2.0},
    {"desc": "Swap arg left: undo", "keys": "(", "pause": 1.0}
  ]
}
-->

---

## 6. Auto-pairs — `mini.pairs`

Brackets, quotes, and parentheses auto-close. Press `<BS>` inside an
empty pair to delete both characters.

**Try it**: In any Lua buffer, type `local x = {` — the `}` auto-closes.
Press `<BS>` inside the empty braces to delete both at once.

---

## Quick Reference

### LSP (`<Leader>l`)

| Key | Action |
|-----|--------|
| `lh` | Hover (type info) |
| `ls` | Go to definition |
| `lR` | Find references |
| `lr` | Rename |
| `la` | Code actions |
| `ld` | Diagnostic popup |
| `li` | Go to implementation |

### Completion

| Key | Action |
|-----|--------|
| `<Tab>` | Next completion item |
| `<S-Tab>` | Previous completion item |
| `<CR>` | Accept completion |
| `<BS>` | Delete paired bracket |

### Formatting (`<Leader>c`)

| Key | Action |
|-----|--------|
| `cf` | Toggle autoformat (buffer) |
| `cF` | Toggle autoformat (global) |

### Arguments

| Key | Action |
|-----|--------|
| `)` | Swap with next argument |
| `(` | Swap with previous argument |
