return {
    {
        'sbdchd/neoformat',
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            vim.g.neoformat_python_docformatter = {
                exe = 'docformatter',
                args = {'--wrap-summaries 88', '--wrap-descriptions 88', '-'},
                stdin = 1,
            }
            vim.g.neoformat_enabled_python = {'docformatter'}
        end,
    },
}
