-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Basic Editor Behavior
vim.g.maplocalleader = " "
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.timeoutlen = 300
vim.scriptencoding = "utf-8"
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"

-- Appearance and Display
vim.o.wrap = true
vim.o.scrolloff = 8
vim.o.numberwidth = 4
vim.o.cursorline = false
vim.o.showtabline = 2
vim.o.conceallevel = 0
-- vim.o.colorcolumn = "80"
-- vim.o.title = true

-- Formatting
vim.o.autoindent = true
vim.o.breakindent = true
vim.o.softtabstop = 2

-- File Handling and Backups
vim.o.backup = false
vim.o.writebackup = false
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir/nvim"
vim.o.swapfile = false
-- vim.g.netrw_dirhistmax = 0
