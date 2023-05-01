return {
    {
        'folke/todo-comments.nvim',
        cmd = {"TodoQuickFix", "TodoTelescope"},
        config = function()
            require('todo-comments').setup()
        end,
    },
}
