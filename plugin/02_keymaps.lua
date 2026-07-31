---02_keymaps — ALL keymaps in one place.
---
---Keymaps are registered eagerly unless they depend on a plugin that may
---not be loaded yet (Flash, mini.keymap).  Those live inside later().
---If a keymap is moved here from another file, a breadcrumb comment is
---left in the original file pointing back to this section.

local later = Config.later

---Set a normal-mode keymap with a description.
---@param lhs  string  Left-hand side (key sequence)
---@param rhs  string|function  Right-hand side (command or callback)
---@param desc string  Human-readable description
local nmap = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end

---Set a leader-prefixed normal-mode keymap.
---@param suf  string  Suffix after <Leader> (e.g. 'ff' for <Leader>ff)
---@param rhs  string|function
---@param desc string
local nmap_leader = function(suf, rhs, desc)
  vim.keymap.set('n', '<Leader>' .. suf, rhs, { desc = desc })
end

-- Leader Clue Groups (for mini.clue)
Config.leader_group_clues = {
  { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
  { mode = 'n', keys = '<Leader>e', desc = '+Explore/Edit/Execute' },
  { mode = 'n', keys = '<Leader>f', desc = '+Find' },
  { mode = 'n', keys = '<Leader>g', desc = '+Git' },
  { mode = 'n', keys = '<Leader>l', desc = '+Language' },
  { mode = 'n', keys = '<Leader>o', desc = '+Open' },
  { mode = 'n', keys = '<Leader>s', desc = '+Flash/Search' },
  { mode = 'n', keys = '<Leader>t', desc = '+Toggle' },
  { mode = 'x', keys = '<Leader>f', desc = '+Find' },
}

-- ==========================================================================
--  General
-- ==========================================================================
nmap('[p', '<Cmd>exe "iput! " . v:register<CR>', 'Paste Above')
nmap(']p', '<Cmd>exe "iput "  . v:register<CR>', 'Paste Below')

-- ==========================================================================
--  Buffers
-- ==========================================================================
nmap_leader('ba', '<Cmd>b#<CR>', 'Alternate')
nmap_leader('bh', '<Cmd>bp<CR>', 'Previous')
nmap_leader('bl', '<Cmd>bn<CR>', 'Next')
nmap_leader('bd', '<Cmd>lua MiniBufremove.delete()<CR>', 'Delete')
nmap_leader('bs', function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end, 'Scratch')
nmap_leader('bw', '<Cmd>lua MiniBufremove.wipeout()<CR>', 'Wipeout')

-- ==========================================================================
--  System / Config
-- ==========================================================================
nmap_leader('ei', '<Cmd>edit $MYVIMRC<CR>', 'init.lua')
nmap_leader('ey', '<Cmd>@"<CR>', 'Execute yeeted text')
nmap_leader('en', '<Cmd>lua MiniNotify.show_history()<CR>', 'Notifications')
nmap_leader('eq', function()
  vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and 'cclose' or 'copen')
end, 'Quickfix')

-- ==========================================================================
--  Toggles
-- ==========================================================================
nmap_leader('tf', function()
  if vim.b.disable_autoformat then
    vim.cmd 'ConformEnable'
    vim.notify 'Enabled autoformat for current buffer'
  else
    vim.cmd 'ConformDisable!'
    vim.notify 'Disabled autoformat for current buffer'
  end
end, 'Format (buffer)')
nmap_leader('tF', function()
  if vim.g.disable_autoformat then
    vim.cmd 'ConformEnable'
    vim.notify 'Enabled autoformat globally'
  else
    vim.cmd 'ConformDisable'
    vim.notify 'Disabled autoformat globally'
  end
end, 'Format (global)')
nmap_leader('tg', '<Cmd>lua MiniDiff.toggle_overlay()<CR>', 'Git diff overlay')
nmap_leader('tn', function()
  if vim.o.relativenumber then
    vim.o.relativenumber = false
    vim.o.number = false
  elseif vim.o.number then
    vim.o.relativenumber = true
  else
    vim.o.number = true
  end
end, 'Line numbers')
nmap_leader('tm', '<Cmd>Markview<CR>', 'Markdown preview')
nmap_leader('ts', function()
  if vim.o.spelllang == 'en' then
    vim.o.spelllang = 'fr'
    vim.o.spell = true
  else
    vim.o.spelllang = 'en'
    vim.o.spell = true
  end
  vim.notify('Spell: ' .. vim.o.spelllang, vim.log.levels.INFO)
end, 'Spell language (en/fr)')

-- ==========================================================================
--  Open
-- ==========================================================================
nmap_leader('oc', '<Cmd>CodeBlockEdit<CR>', 'Code block')
nmap_leader('of', function()
  local file = vim.fn.expand '<cfile>'
  if file == '' then
    vim.notify('No file under cursor', vim.log.levels.WARN)
    return
  end
  if vim.fn.isdirectory(file) == 1 then
    vim.cmd('Oil ' .. vim.fn.fnameescape(file))
    return
  end
  local ext = vim.fn.fnamemodify(file, ':e'):lower()
  local image_exts = { png = true, jpg = true, jpeg = true, gif = true, webp = true, bmp = true }
  if ext == 'pdf' then
    vim.fn.jobstart { 'zathura', '--fork', file }
  elseif image_exts[ext] then
    vim.fn.jobstart { 'feh', file }
  else
    vim.cmd('edit ' .. vim.fn.fnameescape(file))
  end
end, 'File under cursor')

-- ==========================================================================
--  LSP (registered eagerly — vim.lsp.buf functions NOP when no client)
-- ==========================================================================
do
  local function lsp_map(suf, rhs, desc)
    vim.keymap.set('n', '<Leader>l' .. suf, rhs, { desc = desc })
  end
  lsp_map('a', '<Cmd>lua vim.lsp.buf.code_action()<CR>', 'Actions')
  lsp_map('d', '<Cmd>lua vim.diagnostic.open_float()<CR>', 'Diagnostic popup')
  lsp_map('i', '<Cmd>lua vim.lsp.buf.implementation()<CR>', 'Implementation')
  lsp_map('h', '<Cmd>lua vim.lsp.buf.hover()<CR>', 'Hover')
  lsp_map('r', '<Cmd>lua vim.lsp.buf.rename()<CR>', 'Rename')
  lsp_map('R', '<Cmd>lua vim.lsp.buf.references()<CR>', 'References')
  lsp_map('s', '<Cmd>lua vim.lsp.buf.definition()<CR>', 'Source definition')
end

-- ==========================================================================
--  Git hunk navigation
-- ==========================================================================
nmap(']h', function()
  if vim.wo.diff then
    return ']h'
  end
  vim.schedule(function()
    require('mini.diff').next_hunk()
  end)
  return '<Ignore>'
end, 'Next git hunk')
nmap('[h', function()
  if vim.wo.diff then
    return '[h'
  end
  vim.schedule(function()
    require('mini.diff').prev_hunk()
  end)
  return '<Ignore>'
end, 'Previous git hunk')

-- ==========================================================================
--  Plugin-dependent keymaps (registered after plugins load)
-- ==========================================================================
later(function()
  -- Flash.nvim — fast jump navigation
  vim.pack.add { 'https://github.com/folke/flash.nvim' }
  require('flash').setup {}
  vim.keymap.set({ 'n', 'x', 'o' }, '<leader>s', function()
    require('flash').jump()
  end, { desc = 'Flash Jump' })
  vim.keymap.set({ 'n', 'x', 'o' }, '<leader>S', function()
    require('flash').treesitter_search()
  end, { desc = 'Treesitter Search' })
  vim.keymap.set('o', 'r', function()
    require('flash').remote()
  end, { desc = 'Remote Flash' })

  -- mini.keymap — completion-menu navigation + auto-pairs backspace/enter
  -- Each key tries a series of actions in order; the first one that does
  -- something wins, so there's no conflict between pmenu and minipairs.
  require('mini.keymap').setup()
  MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
  MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
  MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
  MiniKeymap.map_multistep('i', '<BS>', { 'minipairs_bs' })
end)
