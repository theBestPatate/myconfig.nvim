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
| `fd` | `emerge fd` | `apt install fd-find` | fzf-lua file listing |
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
| `stylua` | Lua formatting | auto | — |
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
| `black` + `isort` | Python | `pip install black isort` |
| `prettierd` | HTML, CSS, JS, TS, JSX, TSX | `npm install -g @fsouza/prettierd` |
| `csharpier` | C# | `dotnet tool install -g csharpier` |

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
| `aA` / `iA` | Function call |
| `as` | Enclosing scope |

**Move** (also works in operator-pending: `d]m`, `v]M`, etc.):

| Key | Jump to |
|-----|---------|
| `]m` / `[m` | Next / prev function start |
| `]M` / `[M` | Next / prev function end |
| `]]` / `[[` | Next / prev class start |
| `][` / `[]` | Next / prev class end |
| `]o` / `[o` | Next / prev loop |
| `]i` / `[i` | Next / prev conditional |

### Repeat moves

| Key | Action |
|-----|--------|
| `;` | Repeat last move / `f` / `t` forward |
| `,` | Repeat last move / `f` / `t` backward |

### Other

| Key | Action |
|-----|--------|
| `<Leader>or` | Resize window to default |
| `<Leader>ot` | Trim trailing whitespace |
| `<Leader>oz` | Zoom toggle |
| `<Leader>tt` | Terminal (vertical split) |
| `<Leader>tT` | Terminal (horizontal split) |
| `[p` / `]p` | Paste above / below |
| `(` / `)` | Swap argument left / right |

---

## Plugin Roster

| Plugin | Purpose |
|--------|---------|
| [mini.nvim](https://github.com/nvim-mini/mini.nvim) | Core framework — icons, statusline, tabline, completion, snippets, pairs, comment, surround, clue, diff, notify, indentscope, move, splitjoin, align, trailspace, operators, keymap, bufremove, misc |
| [catppuccin](https://github.com/catppuccin/nvim) | Colorscheme (Macchiato variant) |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting, folds, indentation |
| [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | Select, move, swap code by structure |
| [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) | Sticky context at top of window |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Autoformatting on save |
| [flash.nvim](https://github.com/folke/flash.nvim) | Fast in-buffer navigation with labels |
| [fzf-lua](https://github.com/ibhagwan/fzf-lua) | Fuzzy finder, live grep, buffer switcher, git status |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git gutter signs |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Surround operations (add, change, delete) |
| [zen-mode.nvim](https://github.com/folke/zen-mode.nvim) | Distraction-free editing |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | LSP server installer |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP server configurations |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | Pre-made snippet collection |
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
| `demos/editing.md` | mini.pairs, surround, move, align, operators |
| `demos/coding.md` | LSP, completion, snippets, conform, codediff |
| `demos/git.md` | gitsigns, mini.git, mini.diff |

> **Recording demos**: `<!--DEMO-->` blocks inside each file contain JSON
> steps that can be replayed via `tmux send-keys` to generate GIF previews.
> See the `scripts/replay.sh` helper.

---

## Maintenance

| Action | Command |
|--------|---------|
| Update all plugins | `:PackUpdate` |
| Install new plugin | Add `vim.pack.add({ "url" })` to a plugin file, restart |
| Show notifications | `<Leader>en` |
| Edit config | `<Leader>ei` |
