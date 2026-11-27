local function map(mode, lhs, rhs, opts)
	vim.keymap.set(
		mode,
		lhs,
		rhs,
		vim.tbl_extend("force", {
			silent = true,
		}, opts or {})
	)
end

-- Editing without overwriting registers
map({ "n", "x" }, "x", '"_x', { desc = "Delete without yanking" })
map({ "n", "x" }, "X", '"_X', { desc = "Delete without yanking backward" })
map({ "n", "x" }, "c", '"_c', { desc = "Change without yanking" })
map({ "n", "x" }, "C", '"_C', { desc = "Change without yanking to end of line" })
map("x", "p", "P", { desc = "Paste without overwriting register" })

-- Movement
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "B", "^", { desc = "First nonblank character" })
map("n", "E", "$", { desc = "End of line" })

-- Move lines using LazyVim's existing mappings
map({ "n", "x" }, "J", "<A-j>", { remap = true, desc = "Move lines down" })
map({ "n", "x" }, "K", "<A-k>", { remap = true, desc = "Move lines up" })

-- Exit insert mode
map("i", "jk", "<Esc>")
map("i", "kj", "<Esc>")
map("i", "<C-c>", "<Esc>")

-- Search navigation and centering
map("n", "n", "'Nn'[v:searchforward] . 'zzzv'", {
	expr = true,
	desc = "Next search result",
})

map("n", "N", "'nN'[v:searchforward] . 'zzzv'", {
	expr = true,
	desc = "Previous search result",
})

-- Clear search highlighting, snippets, and Noice messages
map({ "n", "i", "s" }, "<Esc>", function()
	vim.cmd.nohlsearch()
	LazyVim.cmp.actions.snippet_stop()

	if package.loaded["noice"] then
		vim.schedule(function()
			require("noice").cmd("dismiss")
		end)
	end

	return "<Esc>"
end, { expr = true, desc = "Escape and clear search" })

-- Save without leaving the current mode
map({ "n", "i", "x" }, "<C-s>", "<cmd>write<cr>", {
	desc = "Save file",
})

-- Plugins
map("n", "<leader>rn", ":IncRename ", {
	silent = false,
	desc = "Incremental rename",
})
