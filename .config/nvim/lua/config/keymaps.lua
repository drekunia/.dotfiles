-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Disable the `Q` key
vim.keymap.set("n", "Q", "<nop>")

-- For conciseness
local opts = { noremap = true, silent = true }

-- Disable spacebar default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Allow moving cursor through wrapped lines with j,k
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Clear highlights
vim.keymap.set("n", "<Esc>", ":noh<CR>", opts)

-- Delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Moves to the EOL with `E` and BOL with `B`
vim.keymap.set("n", "E", "$", { noremap = false })
vim.keymap.set("n", "B", "^", { noremap = false })

-- Navigate through quickfix and location lists and center the cursor
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz")

-- Press jk fast to exit insert mode
vim.keymap.set("i", "jk", "<ESC>", opts)
vim.keymap.set("i", "kj", "<ESC>", opts)
vim.keymap.set("i", "jj", "<ESC>", opts)
vim.keymap.set("i", "kk", "<ESC>", opts)

-- Maps `<C-c>` to `ESC` in insert mode
vim.keymap.set("i", "<C-c>", "<Esc>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Move selected text up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Keep last yangked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

-- Copies text to the system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>Y", [["+Y]])

-- Pastes from 0 register using `<leader>p` and `<leader>P`
vim.keymap.set({ "n", "v" }, "<leader>p", '"0p')
vim.keymap.set({ "n", "v" }, "<leader>P", '"0P')

-- Change text without affecting registers
vim.keymap.set({ "n", "v" }, "<leader>c", '"_c')
vim.keymap.set({ "n", "v" }, "<leader>C", '"_C')
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')
vim.keymap.set({ "n", "v" }, "<leader>D", '"_D')

-- Tab management
-- vim.keymap.set("n", "te", ":tabedit<Return>")
vim.keymap.set("n", "<tab>", ":tabnext<Return>", opts)
vim.keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
