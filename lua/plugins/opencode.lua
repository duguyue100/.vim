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
        vim.g.opencode_opts = {
            port = 8192,
            -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
            provider = {
                enabled = "tmux",
                tmux = {
                    options = "-h -t 1"
              -- ...
            }
          }
        }

        -- Required for `opts.events.reload`.
        vim.o.autoread = true
    end,
}
