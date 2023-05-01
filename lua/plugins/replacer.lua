return {
    {
        'gabrielpoca/replacer.nvim',
        keys = {
            { "<leader>h", "<cmd>lua require('replacer').run()<cr>", desc="Run replacer" },
        },
        config = function()
                require('replacer').setup()
            end,
        },
    }
