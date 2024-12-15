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
            notifier = { enabled = true },
        },
        keys = {
            { "<leader>gb", function() Snacks.gitbrowse() end, desc = "Git Browse" },
            { "<leader>z",  function() Snacks.zen.zen() end, desc = "Toggle Zen Mode" },
            { "<leader>lg",  function() Snacks.lazygit() end, desc = "LazyGit" },
        },
    },
}
