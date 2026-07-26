---Set a normal-mode keymap with a description.
---@param lhs  string  Left-hand side (key sequence)
---@param rhs  string|function  Right-hand side (command or callback)
---@param desc string  Human-readable description
local nmap = function(lhs, rhs, desc)
	vim.keymap.set("n", lhs, rhs, { desc = desc })
end

---Set a leader-prefixed normal-mode keymap.
---@param suf  string  Suffix after <Leader> (e.g. 'ff' for <Leader>ff)
---@param rhs  string|function
---@param desc string
local nmap_leader = function(suf, rhs, desc)
	vim.keymap.set("n", "<Leader>" .. suf, rhs, { desc = desc })
end

---Set a leader-prefixed visual-mode keymap.
---@param suf  string  Suffix after <Leader>
---@param rhs  string|function
---@param desc string
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
	{ mode = "n", keys = "<Leader>o", desc = "+Open" },
	{ mode = "n", keys = "<Leader>s", desc = "+Flash/Search" },
	{ mode = "x", keys = "<Leader>f", desc = "+Find" },
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

-- Open
nmap_leader("oc", "<Cmd>CodeBlockEdit<CR>", "Code block")
nmap_leader("of", function()
	local file = vim.fn.expand("<cfile>")
	if file == "" then
		vim.notify("No file under cursor", vim.log.levels.WARN)
		return
	end
	-- Directory → Oil
	if vim.fn.isdirectory(file) == 1 then
		vim.cmd("Oil " .. vim.fn.fnameescape(file))
		return
	end
	local ext = vim.fn.fnamemodify(file, ":e"):lower()
	local image_exts = { png = true, jpg = true, jpeg = true, gif = true, webp = true, bmp = true }
	if ext == "pdf" then
		vim.fn.jobstart({ "zathura", "--fork", file })
	elseif image_exts[ext] then
		vim.fn.jobstart({ "feh", file })
	else
		vim.cmd("edit " .. vim.fn.fnameescape(file))
	end
end, "File under cursor")
