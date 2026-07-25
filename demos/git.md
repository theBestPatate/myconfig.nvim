# Git

> Open this file in Neovim, set filetype, and follow along:
> `:set ft=markdown`
>
> Press `<Space>` and wait — mini.clue shows `<Leader>g` = `+Git`.

---

## 1. Gitsigns — Gutter Signs & Hunk Navigation

Gitsigns shows `+`, `~`, `_` in the sign column for added, changed, and deleted lines.

### What Are Hunks?

A **hunk** is a contiguous block of changed lines in a file — the same thing you
see in `git diff` output. If you edited 3 separate functions in a file, you have
3 hunks. Gitsigns lets you jump between them instantly.

```
  10  def unchanged_function():         ← unchanged code
  11      pass
+ 12  def newly_added():                ┐
+ 13      return "hello"                │ hunk #1 (addition)
  14                                    ┘
~ 15  def modified_function():          ┐
~ 16      old_name = "x"                 │ hunk #2 (modification)
+ 17      new_name = "y"                 │
  18                                    ┘
_ 19  def old_function():               ┐
_ 20      pass                           │ hunk #3 (deletion)
  21                                    ┘
  22  def other_unchanged():            ← unchanged code
```

### `]h` / `[h` — Jump Between Hunks

| Key | Action |
|-----|--------|
| `]h` | Jump to the **next** hunk below the cursor |
| `[h` | Jump to the **previous** hunk above the cursor |

Mnemonic: `]` = forward, `[` = backward, `h` = **h**unk (same pattern as `]d` for
diagnostics, `]m` for functions).

**Why this is useful**: Instead of scrolling through a long file hunting for
your edits, `]h` takes you straight to each change in order. Before committing,
quickly review every hunk with `]h` `]h` `]h` — you'll never miss a stray edit
or debug print again.

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
