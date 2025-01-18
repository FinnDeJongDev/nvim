require 'options'
require 'keybinds'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end --@diagnostic disable-next-line: undefined-field

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    checker = { enabled = true },

    'tpope/vim-sleuth',
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
            },
        },
    },

    -- Fuzzy finder
    {
        'ibhagwan/fzf-lua',
        config = function()
            require("fzf-lua").setup({
                files = {
                    multiprocess = true,
                },
            })
            vim.keymap.set('n', '<leader>sf', require('fzf-lua').files, { desc = 'fzf files' })
            vim.keymap.set('n', '<leader>sw', require('fzf-lua').grep_cword, { desc = 'fzf grep cword' })
            vim.keymap.set('n', '<Esc><Esc>', require('fzf-lua').buffers, { desc = 'fzf buffers' })
            vim.keymap.set('n', 'gd', require('fzf-lua').lsp_definitions, { desc = 'lsp definitions' })
            vim.keymap.set('n', '<leader>D', require('fzf-lua').lsp_typedefs)
        end,
    },

    -- Bottom VIM line
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            return require('lualine').setup({
                options = {
                    theme = 'codedark'
                }
            })
        end,
    },

    -- Theme
    {
        'olimorris/onedarkpro.nvim',
        priority = 1000,
        config = function()
            require('onedarkpro').setup({
                colors = {
                    cursorline = "#3b3b3b",
                },
                options = {
                    transparency = true,
                    cursorline = true,
                }
            })
        end
    },

    -- Main LSP config
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'stevearc/conform.nvim',
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/nvim-cmp',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'j-hui/fidget.nvim',
        },

        config = function()
            require('conform').setup({
                formatters_by_ft = {}
            })
            local cmp = require('cmp')
            local cmp_lsp = require('cmp_nvim_lsp')
            local capabilities = vim.tbl_deep_extend('force', {}, vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities())

            require('fidget').setup({})
            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'lua_ls',
                    'rust_analyzer',
                },
                handlers = {
                    function(server_name)
                        require('lspconfig')[server_name].setup {
                            capabilities = capabilities
                        }
                    end,
                    ['lua_ls'] = function()
                        local lspconfig = require('lspconfig')
                        lspconfig.lua_ls.setup {
                            capabilities = capablities,
                            settings = {
                                Lua = {
                                    runtime = { version = 'lua 5.3.5' },
                                    diagnostics = {
                                        globals = { 'bit', 'vim', 'it', 'describe', 'before_each', 'after_each' },
                                    }
                                }
                            }
                        }
                    end,
                }
            })

            local cmp_select = { behaviour = cmp.SelectBehavior.Select }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = 'buffer' },
                })
            })

            vim.diagnostic.config({
                float = {
                    focusable = false,
                    style = 'minimal',
                    border = 'rounded',
                    source = 'always',
                    header = '',
                    prefix = '',
                },
            })


            -- Auto format on save
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then return end
                    if client.supports_method('textDocument/formating') then
                        -- Format the current buffer on save
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            buffer = args.buf,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                            end,
                        })
                    end
                end,
            })

            vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show info about that under cursor' })
        end
    },

    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        opts = {
        },
    },

    -- Comments
    {
        'numToStr/Comment.nvim',
        opts = {},
    },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query' },

                auto_install = true,

                hightlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                }
            })
        end,
    },

    -- HTML autoclose tag
    {
        'windwp/nvim-ts-autotag',
        config = function()
            require('nvim-ts-autotag').setup({
                opts = {
                    enable_close = true,
                    enable_rename = true,
                    enable_close_on_slash = false
                },
            })
        end
    }

})

vim.cmd('colorscheme onedark_dark')
