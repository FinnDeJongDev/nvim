return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "onedark",
					globalstatus = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { { "filename", path = 1, icon = "\u{f07b}" } },
					lualine_c = {},
					lualine_x = {
						{
							function()
								local clients = vim.lsp.get_clients({ bufnr = 0 })
								if #clients == 0 then
									return "No LSP"
								end
								local names = {}
								for _, c in ipairs(clients) do
									table.insert(names, c.name)
								end
								return " " .. table.concat(names, ", ")
							end,
						},
					},
					lualine_y = { "progress" },
					lualine_z = {
						{
							function()
								return "\u{f017} " .. os.date("%H:%M")
							end,
						},
					},
				},
			})
		end,
	},
}
