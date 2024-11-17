-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Basic Editor Behavior
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = "menuone,noselect"
vim.opt.isfname:append("@-@")
vim.scriptencoding = "utf-8"
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"

-- Appearance and Display
vim.wo.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.wo.signcolumn = "yes"
vim.o.linebreak = true
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.numberwidth = 4
vim.o.cursorline = false
vim.o.showtabline = 2
vim.o.conceallevel = 0
-- vim.opt.colorcolumn = "80"

-- Formatting
vim.o.title = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.breakindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- File Handling and Backups
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = true
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir/nvim"
vim.o.swapfile = false
-- vim.g.netrw_dirhistmax = 0
