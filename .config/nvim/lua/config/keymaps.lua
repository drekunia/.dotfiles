-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- For conciseness
local opts = { noremap = true, silent = true }

-- Additions
-- Delete without copying into register
vim.keymap.set({ "n", "v" }, "x", '"_x', opts)

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Moves to the EOL with `E` and BOL with `B`
vim.keymap.set("n", "E", "$", opts)
vim.keymap.set("n", "B", "^", opts)

-- Press jk fast to exit insert mode
vim.keymap.set("i", "jk", "<ESC>", opts)
vim.keymap.set("i", "kj", "<ESC>", opts)

-- Maps `<C-c>` to `ESC` in insert mode
vim.keymap.set("i", "<C-c>", "<Esc>", opts)

-- Keep last yangked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

-- Change text without affecting registers
vim.keymap.set({ "n", "v" }, "c", '"_c', opts)
vim.keymap.set({ "n", "v" }, "C", '"_C', opts)

-- Plugins
-- inc-rename
vim.keymap.set("n", "<leader>rn", ":IncRename ")

-- Overwrite LazyVim
-- Move selected text up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)
vim.keymap.set("n", "J", "<cmd>execute 'move .+' . v:count1<cr>==", opts)
vim.keymap.set("n", "K", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", opts)
