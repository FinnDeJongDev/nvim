return {
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("trouble").setup({
				auto_close = true,
			})

			local map = vim.keymap.set
			map("n", "<leader>td", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Document diagnostics" })
			map("n", "<leader>tq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix list" })
		end,
	},
}
