return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local fzf = require("fzf-lua")

			fzf.setup({
				winopts = {
					height = 0.85,
					width = 0.80,
					preview = {
						layout = "horizontal",
						vertical = "right:50%",
					},
				},
				previewers = {
					bat = {
						cmd = "bat",
						args = "--style=numbers,changes --color=always --theme=OneHalfDark",
					},
				},
				defaults = {
					previewer = "bat",
				},
			})

			local map = vim.keymap.set

			map("n", "<leader>sf", function()
				fzf.files({ previewer = false })
			end, { desc = "Find files" })

			map("n", "<leader>sg", fzf.live_grep, { desc = "Live grep" })
			map("n", "<leader>sb", fzf.buffers, { desc = "Find buffers" })
			map("n", "<leader>sw", fzf.grep_cword, { desc = "Find word under cursor" })
			map("n", "<leader>fh", fzf.help_tags, { desc = "Find help tags" })
			map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
			map("n", "<leader>fd", fzf.diagnostics_document, { desc = "Document diagnostics" })
			map("n", "gd", fzf.lsp_definitions, { desc = "LSP definitions" })
			map("n", "gD", fzf.lsp_declarations, { desc = "LSP declarations" })
			map("n", "gI", fzf.lsp_implementations, { desc = "LSP implementations" })
			map("n", "gr", fzf.lsp_references, { desc = "LSP references" })
			map("n", "<leader>D", fzf.lsp_typedefs, { desc = "LSP type definitions" })
		end,
	},
}
