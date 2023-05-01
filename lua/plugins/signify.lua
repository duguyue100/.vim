return {
    {
        'mhinz/vim-signify',
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            vim.g.signify_vcs_list = { 'git' }
        end,
    },
}
