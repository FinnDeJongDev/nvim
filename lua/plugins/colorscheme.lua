return {
	{
		"olimorris/onedarkpro.nvim",
		priority = 1000, -- Load before other plugins
		config = function()
			require("onedarkpro").setup({
				colors = {
					cursorline = "#3b3b3b",
				},
				options = {
					transparency = true,
					cursorline = true,
				},
			})
			vim.cmd("colorscheme onedark_vivid")
		end,
	},
}
