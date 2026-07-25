local nmap = function(lhs, rhs, desc)
	vim.keymap.set("n", lhs, rhs, { desc = desc })
end
local nmap_leader = function(suf, rhs, desc)
	vim.keymap.set("n", "<Leader>" .. suf, rhs, { desc = desc })
end
local xmap_leader = function(suf, rhs, desc)
	vim.keymap.set("x", "<Leader>" .. suf, rhs, { desc = desc })
end

-- General
nmap("[p", '<Cmd>exe "iput! " . v:register<CR>', "Paste Above")
nmap("]p", '<Cmd>exe "iput "  . v:register<CR>', "Paste Below")

-- Leader Clue Groups (for mini.clue)
Config.leader_group_clues = {
	{ mode = "n", keys = "<Leader>b", desc = "+Buffer" },
	{ mode = "n", keys = "<Leader>e", desc = "+Explore/Edit/Execute" },
	{ mode = "n", keys = "<Leader>f", desc = "+Find" },
	{ mode = "n", keys = "<Leader>g", desc = "+Git" },
	{ mode = "n", keys = "<Leader>l", desc = "+Language" },
	{ mode = "n", keys = "<Leader>m", desc = "+Map" },
	{ mode = "n", keys = "<Leader>o", desc = "+Other" },
	{ mode = "n", keys = "<Leader>s", desc = "+Session" },
	{ mode = "n", keys = "<Leader>t", desc = "+Terminal" },
	{ mode = "n", keys = "<Leader>v", desc = "+Visits" },
	{ mode = "x", keys = "<Leader>g", desc = "+Git" },
	{ mode = "x", keys = "<Leader>l", desc = "+Language" },
}

-- Buffers
nmap_leader("ba", "<Cmd>b#<CR>", "Alternate")
nmap_leader("bh", "<Cmd>bp<CR>", "Previous")
nmap_leader("bl", "<Cmd>bn<CR>", "Next")
nmap_leader("bd", "<Cmd>lua MiniBufremove.delete()<CR>", "Delete")
nmap_leader("bs", function()
	vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end, "Scratch")
nmap_leader("bw", "<Cmd>lua MiniBufremove.wipeout()<CR>", "Wipeout")

-- System / Config Edit
nmap_leader("ei", "<Cmd>edit $MYVIMRC<CR>", "init.lua")
nmap_leader("ey", '<Cmd>@"<CR>', "Execute yeeted text")
nmap_leader("en", "<Cmd>lua MiniNotify.show_history()<CR>", "Notifications")
nmap_leader("eq", function()
	vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and "cclose" or "copen")
end, "Quickfix")

-- Map & UI overrides
nmap_leader("or", "<Cmd>lua MiniMisc.resize_window()<CR>", "Resize default")
nmap_leader("ot", "<Cmd>lua MiniTrailspace.trim()<CR>", "Trim trailspace")
nmap_leader("oz", "<Cmd>lua MiniMisc.zoom()<CR>", "Zoom toggle")

-- Terminals
nmap_leader("tT", "<Cmd>horizontal term<CR>", "Terminal (horizontal)")
nmap_leader("tt", "<Cmd>vertical term<CR>", "Terminal (vertical)")
