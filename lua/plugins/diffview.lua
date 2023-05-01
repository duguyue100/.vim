return {
    {
        'sindrets/diffview.nvim',
        cmd = {"DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewRefresh"},
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
    },
}
