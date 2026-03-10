return {
	{
		"stevearc/dressing.nvim",
		config = function()
			require("dressing").setup({
				input = {
					enabled = true,
					win_options = { winblend = 0 },
				},
				select = {
					enabled = true,
					backend = { "fzf_lua", "builtin" },
				},
			})
		end,
	},
}
