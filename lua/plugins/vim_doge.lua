return {
    {
        'kkoomen/vim-doge',
        event = { "BufReadPre", "BufNewFile" },
        build = ':call doge#install()',
        config = function()
            vim.g.doge_doc_standard_python = 'google'
        end,
    },
}
