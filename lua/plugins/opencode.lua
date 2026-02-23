return {
    "NickvanDyke/opencode.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        -- Recommended for `ask()` and `select()`.
        -- Required for `snacks` provider.
        ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
        { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
        ---@type opencode.Opts
        vim.g.opencode_opts = {}

        -- Required for `opts.events.reload`.
        vim.o.autoread = true
    end,
}
