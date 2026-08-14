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
            local capabilities = require('cmp_nvim_lsp').default_capabilities(
                vim.lsp.protocol.make_client_capabilities()
            )
            vim.lsp.config(
                'ty',
                {
                    capabilities = capabilities
                }
            )

            vim.lsp.config('ts_ls', {capabilities = capabilities})
            vim.lsp.enable('ts_ls')

            vim.lsp.config('gopls', {})

            vim.lsp.config('rust_analyzer', {})

            vim.lsp.config(
                'lua_ls',
                {
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
            )
        end
    },
}
