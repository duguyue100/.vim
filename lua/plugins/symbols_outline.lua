return {
    {
        'duguyue100/symbols-outline.nvim',
        cmd = {"SymbolsOutline", "SymbolsOutlineOpen"},
        config = function()
            require('symbols-outline').setup()
        end,
    },
}
