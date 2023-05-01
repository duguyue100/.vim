return {
    {
        'terrortylor/nvim-comment',
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require('nvim_comment').setup(
                {
                    operator_mapping = "<leader>cc",
                }
            )
        end,
    },
}
