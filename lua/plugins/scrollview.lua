return {
    {
        'dstein64/nvim-scrollview',
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            vim.g.scrollview_excluded_filetypes = {'nerdtree'}
            vim.g.scrollview_current_only = 1
            vim.g.scrollview_winblend = 75
            vim.cmd[[highlight ScrollView ctermbg=159 guibg=LightCyan]]
        end,
    },
}
