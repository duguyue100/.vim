return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            scroll = { enabled = true },
            gitbranch = { enabled = true },
            indent = {
                enabled = true,
                only_scope = true,
            },
            toggle = { enable = true },
            zen = { enabled = true },
        },
        keys = {
            { "<leader>gb", function() Snacks.gitbrowse() end, desc = "Git Browse" },
            { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
        },
    },
}
