return {
	-- Mason: installs LSP servers
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	-- Auto-installs formatters and linters
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"biome",
					"prettier",
					"stylua",
				},
				auto_update = false,
				run_on_start = true,
			})
		end,
	},

	-- Bridges mason and lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls", -- TypeScript / JavaScript
					"html", -- HTML
					"cssls", -- CSS
					"tailwindcss", -- Tailwind CSS
					"eslint", -- ESLint
					"jsonls", -- JSON (next.config.json, tsconfig.json, etc.)
					"emmet_ls", -- Emmet for HTML/JSX
					"lua_ls", -- Lua
				},
				automatic_installation = true,
			})
		end,
	},

	-- LSP config
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(_, bufnr)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
				end

				map("K", vim.lsp.buf.hover, "Hover docs")
				map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
				map("<leader>ca", vim.lsp.buf.code_action, "Code action")
				map("<leader>d", vim.diagnostic.open_float, "Open diagnostic")
				map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
				map("]d", vim.diagnostic.goto_next, "Next diagnostic")
			end

			local servers = {
				"html",
				"cssls",
				"tailwindcss",
				"eslint",
				"jsonls",
				"emmet_ls",
			}

			for _, server in ipairs(servers) do
				lspconfig[server].setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})
			end

			-- lua_ls needs special setup to understand the Neovim runtime
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			})

			-- ts_ls needs special setup for React/Next.js
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					typescript = {
						preferences = { importModuleSpecifier = "relative" },
					},
					javascript = {
						preferences = { importModuleSpecifier = "relative" },
					},
				},
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
			})
		end,
	},
}
