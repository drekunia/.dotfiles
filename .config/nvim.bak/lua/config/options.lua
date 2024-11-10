-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable absolute line numbers and relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tab settings
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Disable swapfile and backup files
vim.opt.swapfile = false
vim.opt.backup = false

-- Enable persistent undo by setting undodir
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Disable highlighting of search results and enable incremental search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Enable true color
vim.opt.termguicolors = true

-- Keep 8 line visible above and below cursor
vim.opt.scrolloff = 8

-- Always show the sign column
vim.opt.signcolumn = "yes"

-- Allows `@-@` in filename
vim.opt.isfname:append("@-@")

-- Set the delay for triggering events
vim.opt.updatetime = 50

-- Highlight column 80 to guide line break
-- vim.opt.colorcolumn = "80"

-- Encoding UTF-8
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- Title and indentation
vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true
