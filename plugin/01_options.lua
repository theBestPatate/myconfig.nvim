---01_options — core editor settings: UI, editing behaviour, completion.
---Applied early so every other plugin inherits these defaults.

-- General
vim.g.mapleader = ' '
vim.o.confirm = true -- ask for confirmation on unsaved changes

-- Disable unused providers to silence :checkhealth warnings.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:1,hor:1'
vim.o.switchbuf = 'usetab'
vim.o.undofile = true
-- shada (Sha-red Da-ta) controls what Neovim remembers between sessions.
--   '100   remember marks (e.g. mA, 'a) for up to 100 files
--   <50    keep registers up to 50 lines each (longer ones are truncated)
--   s10    keep items (macros, etc.) up to 10 KiB each
--   :1000  remember the last 1000 Ex-commands in command-line history
--   /100   remember the last 100 search patterns
--   @100   remember the last 100 input-line entries (e.g. @: repeats)
--   h      do NOT restore the hlsearch highlight on startup
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h"

-- Enable filetype detection, plugin loading, and indent files.
-- Done here (not via a ftplugin) so it runs once at startup.
vim.cmd 'filetype plugin indent on'
if vim.fn.exists 'syntax_on' ~= 1 then
  vim.cmd 'syntax enable'
end

-- UI
vim.o.breakindent = true
vim.o.breakindentopt = 'list:-1'
vim.o.colorcolumn = '+1'
vim.o.cursorline = true
vim.o.linebreak = true
vim.o.list = true
vim.o.number = false
vim.o.relativenumber = false
vim.o.pumborder = 'single'
vim.o.pumheight = 10
vim.o.pummaxwidth = 100
vim.o.ruler = false
-- shortmess flags:
--   C  don't show "pattern not found"       F  don't show file info on :edit
--   O  don't show "reading" message          S  don't show search-count
--   W  don't show "written"                   a  all of the above short forms
--   c  don't show completion messages          o  overwrite read-only messages
vim.o.shortmess = 'CFOSWaco'
vim.o.showmode = false
vim.o.signcolumn = 'yes'
vim.o.splitbelow = true
vim.o.splitkeep = 'screen'
vim.o.splitright = true
vim.o.winborder = 'single'
vim.o.wrap = false
vim.o.cursorlineopt = 'screenline,number'
vim.o.fillchars = 'eob: ,fold:╌'
vim.o.listchars = 'extends:…,nbsp:␣,precedes:…,tab:| '
vim.o.showbreak = '↪ '

-- Folds
vim.o.foldlevel = 10
vim.o.foldmethod = 'indent'
vim.o.foldnestmax = 10
vim.o.foldtext = '' -- disable fold text (only show the fold marker)

-- Editing
vim.o.autoindent = true
vim.o.expandtab = true
-- formatoptions:
--   r  auto-insert comment leader on <Enter>    q  allow 'gq' formatting
--   n  recognize numbered lists                  l  don't break long lines in insert
--   1  don't break after a one-letter word       j  remove comment leader when joining
vim.o.formatoptions = 'rqnl1j'
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.infercase = true
vim.o.shiftwidth = 2
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.spelloptions = 'camel'
vim.o.tabstop = 2
vim.o.virtualedit = 'block'
-- iskeyword:  @  all alpha chars, 48-57  digits, _  underscore,
--             192-255  high ASCII, -  hyphen (so 'foo-bar' is one word)
vim.o.iskeyword = '@,48-57,_,192-255,-'
-- Pattern that starts a list item.  Matches lines like "1.", "- ", "* " etc.
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Built-in completion
-- complete sources:  .  current buffer, w  windows, b  loaded buffers, k  dictionary, spell
vim.o.complete = '.,w,b,kspell'
-- completeopt:  menuone  show menu even with 1 match,  noselect  don't auto-select,
--               fuzzy    fuzzy matching,         nosort    preserve LSP sort order
vim.o.completeopt = 'menuone,noselect,fuzzy,nosort'
vim.o.completetimeout = 100
