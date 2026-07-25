# Git

> Open this file in Neovim, set filetype, and follow along:
> `:set ft=markdown`
>
> Press `<Space>` and wait — mini.clue shows `<Leader>g` = `+Git`.

---

## 1. Gitsigns — Gutter Signs & Hunk Navigation

Gitsigns shows `+`, `~`, `_` in the sign column for added, changed, and deleted lines.
It also provides hunk-level operations.

### `]h` / `[h` — Jump Between Hunks

Jump to the next or previous git hunk in the current file. Works like `]d` / `[d`
for diagnostics, but for git changes.

**Try it**: Open a file with unstaged changes, press `]h` to jump to the first hunk,
`[h` to go back.

### Gitsigns Hunk Actions

| Key | Action |
|-----|--------|
| `<Leader>go` | Toggle inline diff overlay (`mini.diff`) |

---

## 2. fzf-lua Git Status — `<Leader>fs`

Interactive git status with preview. Shows staged, unstaged, and untracked files.

Press `<Leader>fs` to open.

| Action | Key |
|--------|-----|
| Stage / unstage toggle | `<Tab>` |
| Open file | `<CR>` |
| Close | `<Esc>` |

<!--DEMO
{
  "steps": [
    {"desc": "Open git status", "keys": "<Leader>fs", "pause": 2.0},
    {"desc": "Navigate to a file", "keys": "<C-n><C-n>", "pause": 1.0},
    {"desc": "Toggle stage/unstage with Tab", "keys": "<Tab>", "pause": 1.0},
    {"desc": "Close", "keys": "<Esc>", "pause": 0.5}
  ]
}
-->

---

## 3. fzf-lua Git Files — `<Leader>fG`

List all files tracked by Git in the current repository. Useful for jumping to
any file in the project without navigating the directory tree.

Press `<Leader>fG`, type to filter, `<CR>` to open.

---

## Quick Reference

| Key | Action |
|-----|--------|
| `]h` / `[h` | Next / previous git hunk |
| `<Leader>go` | Toggle diff overlay |
| `<Leader>fs` | Git status (fzf-lua, `<Tab>` to stage) |
| `<Leader>fG` | Git-tracked files (fzf-lua) |
