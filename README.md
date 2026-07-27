# myconfig.nvim

Personal Neovim configuration — a fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim),
rebuilt around [mini.nvim](https://github.com/nvim-mini/mini.nvim) and Neovim's native
`vim.pack.add()`.

## Quick Start

```bash
git clone git@github.com:theBestPatate/myconfig.nvim.git ~/.config/nvim
nvim
```

The first launch installs all plugins automatically. Subsequent launches are fast.

> **Requirements**: Neovim ≥ 0.12, Git, and a [Nerd Font](https://www.nerdfonts.com/) for icons.

---

## System Dependencies

Some plugins need binaries on your `$PATH`.

| Package | Gentoo | Debian / Ubuntu | Why |
|---------|--------|-----------------|-----|
| `fd` | `emerge fd` | `apt install fd-find` (binary is `fdfind`, symlink to `fd`) | fzf-lua file listing |
| `fzf` | `emerge fzf` | `apt install fzf` | fzf-lua binary |
| `ripgrep` | `emerge ripgrep` | `apt install ripgrep` | fzf-lua live grep |
| `node` | `emerge nodejs` | `apt install nodejs` | vtsls LSP (TypeScript) |
| Nerd Font | `emerge nerd-fonts` | download from [nerdfonts.com](https://www.nerdfonts.com/) | icons in UI |

---

## LSP Servers

All servers are managed by [mason.nvim](https://github.com/mason-org/mason.nvim) and
auto-installed on first use.

| Server | Language | Mason | Extra setup |
|--------|----------|-------|-------------|
| `lua_ls` | Lua | auto | — |
| `stylua` (stylua-lsp) | Lua formatting | auto | — |
| `tinymist` | Typst | auto | — |
| `marksman` | Markdown | auto | — |
| `vtsls` | TypeScript / JavaScript | auto | `npm install -g typescript` recommended |
| `oxlint` | JavaScript linting | auto | — |
| `superhtml` | HTML | auto | — |
| `ty` | Python type checking | auto | — |

---

## Formatters (conform.nvim)

| Tool | Language | Install |
|------|----------|---------|
| `black` + `isort` | Python | `uv tool install black isort` |
| `prettierd` | HTML, CSS, JS, TS, JSX, TSX | `npm install -g @fsouza/prettierd` |

Install commands:

```bash
# Python formatters (available globally via uv)
uv tool install black isort

# Web formatter (available globally via npm)
npm install -g @fsouza/prettierd
```

Formatting runs on save automatically. Disable it per-buffer with `<Leader>cf`,
globally with `<Leader>cF`.

---

## Keybindings

Leader key is `<Space>`.

### Buffer

| Key | Action |
|-----|--------|
| `<Leader>ba` | Alternate buffer (previous) |
| `<Leader>bh` | Previous buffer |
| `<Leader>bl` | Next buffer |
| `<Leader>bd` | Delete buffer |
| `<Leader>bw` | Wipeout buffer |
| `<Leader>bs` | New scratch buffer |

### Edit / System

| Key | Action |
|-----|--------|
| `<Leader>ei` | Edit `init.lua` |
| `<Leader>ey` | Execute yanked text |
| `<Leader>en` | Show notification history |
| `<Leader>eq` | Toggle quickfix window |

### Find — `<Leader>f` (fzf-lua)

| Key | Action |
|-----|--------|
| `<Leader>ff` | Fuzzy find files |
| `<Leader>fg` | Live grep (visual: extends selection to match) |
| `<Leader>fw` | Grep word (visual: extends selection to match) |
| `<Leader>fb` | Buffer switcher |
| `<Leader>fr` | Resume last search |
| `<Leader>fh` | Help tags |
| `<Leader>fc` | Command palette |
| `<Leader>fo` | Recent files |
| `<Leader>fG` | Git-tracked files |
| `<Leader>fs` | Git status |

### Language / LSP — `<Leader>l`

| Key | Action |
|-----|--------|
| `<Leader>la` | Code actions |
| `<Leader>ld` | Diagnostic popup |
| `<Leader>li` | Go to implementation |
| `<Leader>lh` | Hover |
| `<Leader>lr` | Rename |
| `<Leader>lR` | References |
| `<Leader>ls` | Go to definition |

### Code / Conform — `<Leader>c`

| Key | Action |
|-----|--------|
| `<Leader>cf` | Toggle autoformat (buffer) |
| `<Leader>cF` | Toggle autoformat (global) |

### Git — `<Leader>g`

| Key | Action |
|-----|--------|
| `]h` / `[h` | Next / previous git hunk |
| `<Leader>go` | Toggle diff overlay |

### Flash (fast in-buffer navigation)

| Key | Action |
|-----|--------|
| `<Leader>s` | Jump anywhere on screen with labels |
| `<Leader>S` | Treesitter search |

### Treesitter Text Objects

These work in **visual** (`v`) and **operator-pending** (`d`, `c`, `y`, ...) modes.

| Key | Select |
|-----|--------|
| `af` / `if` | Function (outer / inner) |
| `ac` / `ic` | Class (outer / inner) |
| `aa` / `ia` | Argument / parameter |
| `ai` / `ii` | Conditional (if/else) |
| `al` / `il` | Loop (for/while) |
| `ab` / `ib` | Block |
| `aC` / `iC` | Function call |

### Other

| Key | Action |
|-----|--------|
| `[p` / `]p` | Paste above / below |
| `<Leader>a` / `<Leader>A` | Swap argument left / right |

---

## Plugin Roster

| Plugin | Purpose |
|--------|---------|
| [mini.nvim](https://github.com/nvim-mini/mini.nvim) | Core framework — icons, tabline, completion, pairs, comment, clue, diff, notify, indentscope, move, splitjoin, align, trailspace, operators, keymap, bufremove, misc |
| [chilling-potato](https://github.com/theBestPatate/chilling_potato) | Colorscheme |
| [catppuccin](https://github.com/catppuccin/nvim) | Alternative colorscheme (installed, not active) |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting, folds, indentation |
| [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | Select, move, swap code by structure |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Autoformatting on save |
| [flash.nvim](https://github.com/folke/flash.nvim) | Fast in-buffer navigation with labels |
| [fzf-lua](https://github.com/ibhagwan/fzf-lua) | Fuzzy finder, live grep, buffer switcher, git status |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git gutter signs |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Surround operations (add, change, delete) |
| [zen-mode.nvim](https://github.com/folke/zen-mode.nvim) | Distraction-free editing |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | LSP server installer |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP server configurations |
| [codediff.nvim](https://github.com/esmuellert/codediff.nvim) | Diff viewer |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | Directory-as-buffer editing (`:Oil`). Keybindings removed — use fzf-lua for file navigation. |

---

## Interactive Demos

Each file in `demos/` is a self-contained tutorial. Open it in Neovim, set the
filetype, and follow along.

| File | Covers |
|------|--------|
| `demos/text_objects.md` | Treesitter select, move, swap, repeat |
| `demos/navigation.md` | flash.nvim, fzf-lua |
| `demos/coding.md` | LSP, completion, snippets, conform, codediff |
| `demos/git.md` | gitsigns, mini.diff |

> **Recording demos**: `<!--DEMO-->` blocks inside most demo files contain JSON
> steps that can be replayed via `tmux send-keys` to generate GIF previews.

---

## Maintenance

| Action | Command |
|--------|---------|
| Update all plugins | `:PackUpdate` |
| Install new plugin | Add `vim.pack.add({ "url" })` to a plugin file, restart |
| Show notifications | `<Leader>en` |
| Edit config | `<Leader>ei` |

### Pre-commit hook

A stylua formatter hook lives at `scripts/pre-commit`.  Activate it once after
cloning:

```bash
git config core.hooksPath scripts
```

After that, every `git commit` reformats staged `.lua` files automatically.
