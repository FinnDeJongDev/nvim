return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					javascript = { "biome" },
					javascriptreact = { "biome" },
					typescript = { "biome" },
					typescriptreact = { "biome" },
					json = { "biome" },
					html = { "prettier" },
					css = { "prettier" },
					lua = { "stylua" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
				formatters = {
					prettier = {
						prepend_args = { "--use-tabs", "--tab-width", "2" },
					},
					stylua = {
						prepend_args = { "--indent-type", "Tabs", "--indent-width", "2" },
					},
				},
			})
		end,
	},
}
