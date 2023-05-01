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
        end
    },
}
