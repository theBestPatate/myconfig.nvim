# Navigation

> Open this file in Neovim and set the filetype so code blocks highlight correctly:
> `:set ft=markdown`
>
> Press `<Space>` and wait — mini.clue shows all available groups.
> `<Leader>f` = Find, `<Leader>s` = Flash/Search.

---

## 1. Flash — Jump Anywhere on Screen

Flash shows two-character labels on every visible word. Type the label to jump there.
Faster than `/` and `?` for visible targets.

### `<Leader>s` — Flash Jump

```python
def initialize_database(connection_string, pool_size=10, timeout=30):
    """Create connection pool and run migrations."""
    if not connection_string.startswith("postgresql://"):
        raise ValueError("Only PostgreSQL is supported")

    engine = create_engine(connection_string, pool_size=pool_size)
    Session = sessionmaker(bind=engine)

    logger.info("Connected to %s", connection_string)
    return engine, Session


class DataProcessor:
    def __init__(self, batch_size=100):
        self.batch_size = batch_size
        self.processed = 0

    def transform(self, items):
        results = []
        for item in items:
            if item.is_valid():
                results.append(item.normalize())
        self.processed += len(results)
        return results
```

**Try it**: Put your cursor at the top and press `<Leader>s`. Labels appear on every word.
Type the two characters next to `DataProcessor` — you jump there instantly.

<!--DEMO
{
  "steps": [
    {"desc": "Flash jump to a target word", "keys": "<Leader>sDa", "pause": 2.5},
    {"desc": "Flash jump to 'results'", "keys": "<Leader>sre", "pause": 2.5}
  ]
}
-->

### `<Leader>S` — Treesitter Search

Like Flash Jump, but labels appear on **treesitter nodes** (functions, classes,
loops, conditionals) instead of individual words. Type to filter nodes by name,
then type the label to jump.

**Try it**: Press `<Leader>S` — labels appear on every function and class.
Type `process` to narrow to matching nodes, then type the label next to your target.

<!--DEMO
{
  "steps": [
    {"desc": "Treesitter Search: label all TS nodes", "keys": "<Leader>S", "pause": 2.5},
    {"desc": "Filter: 'process'", "keys": "process", "pause": 2.0},
    {"desc": "Cancel", "keys": "<Esc>", "pause": 1.0}
  ]
}
-->

### `r` — Remote Flash (Operator-Pending)

In **operator-pending mode** (after `d`, `c`, `y`), `r` triggers flash so you can
operate on a remote location without moving your cursor first.

**Try it**: Place cursor on `class DataProcessor:`, then type `drr` followed by
two characters at `logger.info`. The class is deleted up to that point.

---

## 2. fzf-lua — Project-Wide Search

Press `<Leader>f` and mini.clue shows all available find commands.

### fzf-lua Window Layout

```
┌───────────────────────────────────┐  ┌──────────────────┐
│  Search query...                  │  │                  │
├───────────────────────────────────┤  │   File Preview   │
│  header: <A-h> <A-i> <A-f>        │  │   (auto-scrolls) │
│  plugin/35_fzf.lua          [24]  │  │                  │
│  plugin/20_editor.lua       [226] │  │   1  local ...   │
│  plugin/10_ui.lua           [77]  │  │   2  local ...   │
│  ...                              │  │   3  ...         │
└───────────────────────────────────┘  └──────────────────┘
     search + results (fzf)              preview follows
```

| Action | Key |
|--------|-----|
| Start typing | Filters results as you type |
| Navigate results | `<C-n>` next, `<C-p>` previous |
| Scroll preview | `<C-d>` / `<C-u>` half-page |
| Open selected | `<CR>` |
| Close | `<Esc>` |

**Header buttons** (shown in the header bar):
- `<A-h>` — toggle hidden files  
- `<A-i>` — toggle `.gitignore` filtering  
- `<A-f>` — toggle follow symlinks

### `<Leader>ff` — Find Files

Fuzzy-find any file in your project. Matches on path segments, not just filename.

**Try it**: Press `<Leader>ff`, type `nav` — files with "nav" in their path appear.
Use `<C-n>` / `<C-p>` or arrow keys to move, `<CR>` to open, `<Esc>` to cancel.

<!--DEMO
{
  "steps": [
    {"desc": "Open fuzzy file finder", "keys": "<Leader>ff", "pause": 1.5},
    {"desc": "Search for files matching 'nav'", "keys": "nav", "pause": 2.0},
    {"desc": "Cancel with Escape", "keys": "<Esc>", "pause": 1.0}
  ]
}
-->

### `<Leader>fg` — Live Grep

Search every line of every file in the project. Results update as you type.

**In normal mode**: press `<Leader>fg`, type a pattern, `<CR>` to jump to match.

**In visual mode**: start a selection, press `<Leader>fg`, find a match.
When you press `<CR>`, the selection automatically extends from the original
anchor to the match — just like `/` in visual mode, but with fzf.

**Try it**: Press `<Leader>fg`, type `def process` — you'll see all function
definitions matching that pattern, with file path and line number.

<!--DEMO
{
  "steps": [
    {"desc": "Open live grep", "keys": "<Leader>fg", "pause": 1.5},
    {"desc": "Search for 'def process'", "keys": "def process", "pause": 3.0},
    {"desc": "Cancel", "keys": "<Esc><Esc>", "pause": 1.0}
  ]
}
-->

### `<Leader>fw` — Grep Word Under Cursor

Search the project for the word under cursor (normal) or selected text (visual).
In visual mode, the selection extends to the match — same as `<Leader>fg`.

**Try it**: Place your cursor on `DataProcessor` somewhere on this page, press `<Leader>fw`.

### `<Leader>fb` — Buffers

Switch between open buffers with a preview pane.

**Try it**: Open a few files first, then `<Leader>fb`. You'll see a list of all
buffers with a preview of the highlighted one. `<CR>` to open.

<!--DEMO
{
  "steps": [
    {"desc": "Open buffer switcher", "keys": "<Leader>fb", "pause": 2.0},
    {"desc": "Cancel", "keys": "<Esc>", "pause": 1.0}
  ]
}
-->

### `<Leader>fr` — Resume Last Search

Reopens the last fzf-lua window with your previous query still filled in.
Handy when you close the wrong file and want to pick again.

### `<Leader>fh` — Help Tags

Search through Neovim's `:help` documentation. Faster than `:help <topic>` when
you don't know the exact tag name.

**Try it**: Press `<Leader>fh`, type `pack` to browse everything about vim.pack.

### `<Leader>fc` — Command Palette

Fuzzy-search and run any Neovim command. Great for commands you can't remember
the exact spelling of.

**Try it**: Press `<Leader>fc`, type `colo` — all colorscheme-related commands appear.

### `<Leader>fo` — Recent Files

Shows files you've opened recently (from Neovim's oldfiles list).
Quick way to return to a file without navigating your project tree.

### `<Leader>fG` — Git Files

Lists all files tracked by Git in the current repository.
Excludes `.gitignore`-d files automatically via fzf-lua's internal filtering.

---

## Quick Reference

### Flash

| Key | Context | Action |
|-----|---------|--------|
| `<Leader>s` | n, x, o | Jump anywhere with labels |
| `<Leader>S` | n, x, o | Treesitter search (label + filter by node type) |
| `r` | o | Remote flash (after `d`/`c`/`y`) |

### fzf-lua (`<Leader>f`)

| Key | Action |
|-----|--------|
| `ff` | Find files |
| `fg` | Live grep (visual: extends selection to match) |
| `fw` | Grep word (visual: extends selection to match) |
| `fb` | Buffer switcher |
| `fr` | Resume last search |
| `fh` | Help tags |
| `fc` | Command palette |
| `fo` | Recent files |
| `fG` | Git files |


