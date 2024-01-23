return {
    {
        'Shougo/junkfile.vim',
        cmd = "JunkfileOpen",
        config = function()
            vim.cmd [[command! JunkfileOpen call junkfile#open(strftime('%Y-%m-%d-%H%M%S.'))]]
        end,
    },
}
