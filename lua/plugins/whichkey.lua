return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			wk.setup({
				preset = "minimal",
				delay = 500,
			})
			wk.add({
				{ "<leader>f", group = "find" },
				{ "<leader>s", group = "search" },
				{ "<leader>h", group = "git" },
				{ "<leader>t", group = "diagnostics" },
			})
		end,
	},
}
