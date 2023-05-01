return {
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/nvim-cmp',
        },
        config = function()
            local capabilities = require(
            'cmp_nvim_lsp'
            ).default_capabilities(
            vim.lsp.protocol.make_client_capabilities()
            )
            require('lspconfig').jedi_language_server.setup {
                capabilities = capabilities
            }

            require'lspconfig'.tsserver.setup {capabilities = capabilities}

            require'lspconfig'.lua_ls.setup{
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = {'vim'},
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        -- Do not send telemetry data containing a randomized but unique identifier
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            }
        end
    },
}
