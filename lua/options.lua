vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = 'a'

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false

vim.opt.undofile = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 50

vim.opt.splitright = true
vim.opt.splitbelow = false

vim.opt.cursorline = true

vim.opt.scrolloff = 10

vim.opt.list = true
vim.opt.listchars = { tab = "|\\ " }

-- Yank highlight
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking text',
	group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
