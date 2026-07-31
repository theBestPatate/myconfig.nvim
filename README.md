# myconfig.nvim

My personal Neovim configuration ... rebuilt around [mini.nvim](https://github.com/nvim-mini/mini.nvim)
and Neovim's native `vim.pack.add()`.

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
| `fd` | `emerge sys-apps/fd` | `apt install fd-find` (binary is `fdfind`, symlink to `fd`) | fzf-lua file listing |
| `fzf` | `emerge app-shells/fzf` | `apt install fzf` | fzf-lua binary |
| `ripgrep` | `emerge sys-apps/ripgrep` | `apt install ripgrep` | fzf-lua live grep |
| `node` | `emerge net-libs/nodejs` | `apt install nodejs` | vtsls LSP (TypeScript) |
| Nerd Font | `download from [nerdfonts.com](https://www.nerdfonts.com/)` | download from [nerdfonts.com](https://www.nerdfonts.com/) | icons in UI |

---

## LSP Servers

All servers are managed by [mason.nvim](https://github.com/mason-org/mason.nvim) and
auto-installed on first run.

| Server | Language | Extra setup |
|--------|----------|-------------|
| `lua_ls` | Lua | — |
| `stylua` | Lua formatting | — |
| `tinymist` | Typst | — |
| `marksman` | Markdown | — |
| `vtsls` | TypeScript / JavaScript | `npm install -g typescript` recommended |
| `oxlint` | JavaScript linting | — |
| `superhtml` | HTML | — |
| `ty` | Python type checking | — |

---

## Formatters (conform.nvim)

Formatting runs on save automatically.

| Tool | Language | Install |
|------|----------|---------|
| `black` + `isort` | Python | `uv tool install black isort` |
| `prettierd` | HTML, CSS, JS, TS, JSX, TSX | `npm install -g @fsouza/prettierd` |

---

## Keybindings

Leader key is `<Space>`.

### Buffer — `<Leader>b`

| Key | Action |
|-----|--------|
| `<Leader>ba` | Alternate buffer (previous) |
| `<Leader>bh` | Previous buffer |
| `<Leader>bl` | Next buffer |
| `<Leader>bd` | Delete buffer |
| `<Leader>bw` | Wipeout buffer |
| `<Leader>bs` | New scratch buffer |

### Edit / System — `<Leader>e`

| Key | Action |
|-----|--------|
| `<Leader>en` | Show notification history |

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

### Toggle — `<Leader>t`

| Key | Action |
|-----|--------|
| `<Leader>tf` | Toggle autoformat (buffer) |
| `<Leader>tF` | Toggle autoformat (global) |
| `<Leader>tg` | Toggle git diff overlay |
| `<Leader>tm` | Toggle markdown preview (markview) |
| `<Leader>tn` | Cycle line numbers (off → absolute → relative → off) |
| `<Leader>tq` | Toggle quickfix window |
| `<Leader>ts` | Toggle spell language (English ↔ French) |

### Git

| Key | Action |
|-----|--------|
| `]h` / `[h` | Next / previous git hunk (mini.diff) |
| `<Leader>tg` | Toggle diff overlay |

### Flash — `<Leader>s` (fast in-buffer navigation)

| Key | Action |
|-----|--------|
| `<Leader>s` | Jump anywhere on screen with labels |
| `<Leader>S` | Treesitter search |
| `r` (operator-pending) | Remote flash (e.g. `dr` to delete to label) |

### Treesitter Text Objects

Work in **visual** (`v`, `V`) and **operator-pending** (`d`, `c`, `y`, ...) modes.

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
| `<Leader>oc` | Edit injected code block in dedicated buffer (CodeBlockEdit) |
| `<Leader>of` | Open file/directory under cursor |
| `<Leader>a` / `<Leader>A` | Swap argument left / right (swapping-potato) |

---

## Plugin Roster

| Plugin | Purpose |
|--------|---------|
| [mini.nvim](https://github.com/nvim-mini/mini.nvim) | Core framework — icons, tabline, completion, pairs, comment, clue, diff, notify, indentscope, bufremove, misc |
| [chilling-potato](https://github.com/theBestPatate/chilling_potato) | Colorscheme |
| [catppuccin](https://github.com/catppuccin/nvim) | Alternative colorscheme (installed, not active) |
| [swapping-potato](https://github.com/theBestPatate/swapping_potato) | Argument swapping (`<Leader>a` / `<Leader>A`) |
| [markview.nvim](https://github.com/OXY2DEV/markview.nvim) | Live markdown preview (`<Leader>tm`) |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting, folds, indentation |
| [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | Select, move, swap code by structure |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Autoformatting on save |
| [flash.nvim](https://github.com/folke/flash.nvim) | Fast in-buffer navigation with labels |
| [fzf-lua](https://github.com/ibhagwan/fzf-lua) | Fuzzy finder, live grep, buffer switcher, git status |
| [mini.diff](https://github.com/nvim-mini/mini.diff) | Git diff overlay and hunk navigation |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Surround operations (add, change, delete) |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | LSP server installer |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP server configurations |
| [codediff.nvim](https://github.com/esmuellert/codediff.nvim) | Diff viewer |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | Directory-as-buffer editing |
| [zen-mode.nvim](https://github.com/folke/zen-mode.nvim) | Distraction-free editing |
| [nvim-colorizer.lua](https://github.com/catgoose/nvim-colorizer.lua) | Inline hex color preview |

---

## Interactive Demos

Each file in `demos/` is a self-contained tutorial. Open it in Neovim and follow along.

| File | Covers |
|------|--------|
| `demos/text_objects.md` | Treesitter select, move, swap, repeat |
| `demos/navigation.md` | flash.nvim, fzf-lua |
| `demos/coding.md` | LSP, completion, conform, codediff |
| `demos/git.md` | mini.diff |

---

## Maintenance

| Action | Command |
|--------|---------|
| Update all plugins | `:PackUpdate` |
| Wipe & reinstall plugins | `:PackWipe` (then restart nvim) |
| Install new plugin | Add `vim.pack.add({ "url" })` to a plugin file, restart |

### Pre-commit hook

```bash
git config core.hooksPath scripts
```

After activation, every `git commit` reformats staged `.lua` files with stylua.
