local group = vim.api.nvim_create_augroup("CustomAutocmds", { clear = true })

-- Reset manually enabled paste mode when leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
	group = group,
	command = "set nopaste",
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "markdown" },
--   callback = function()
--     vim.opt.conceallevel = 0
--   end,
-- })
