return {
    {
        'is0n/jaq-nvim',
        cmd = "Jaq",
        keys = {
            { "<leader>r", "<cmd>Jaq<cr>", desc = "Run code" },
        },
        config = function()
            require('jaq-nvim').setup{
                -- Commands used with 'Jaq'
                cmds = {
                    -- Default UI used (see `Usage` for options)
                    default = "float",

                    -- Uses external commands such as 'g++' and 'cargo'
                    external = {
                        typescript = "deno run %",
                        javascript = "node %",
                        markdown = "glow %",
                        python = "$(which python) %",
                        -- rust = "rustc % && ./$fileBase && rm $fileBase",
                        rust = "cargo run",
                        cpp = "g++ % -o $fileBase && ./$fileBase",
                        go = "go run %",
                        sh = "sh %",
                    },

                    -- Uses internal commands such as 'source' and 'luafile'
                    internal = {
                        lua = "luafile %",
                        vim = "source %"
                    }
                },

                -- UI settings
                ui = {
                    -- Start in insert mode
                    startinsert = false,

                    -- Switch back to current file
                    -- after using Jaq
                    wincmd      = false,

                    -- Floating Window / FTerm settings
                    float = {
                        -- Floating window border (see ':h nvim_open_win')
                        border    = "rounded",

                        -- Num from `0 - 1` for measurements
                        height    = 0.8,
                        width     = 0.8,
                        x         = 0.5,
                        y         = 0.5,

                        -- Highlight group for floating window/border (see ':h winhl')
                        border_hl = "FloatBorder",
                        float_hj  = "Normal",

                        -- Floating Window Transparency (see ':h winblend')
                        blend = 20
                    },

                    terminal = {
                        -- Position of terminal
                        position = "bot",

                        -- Open the terminal without line numbers
                        line_no = false,

                        -- Size of terminal
                        size     = 10
                    },

                    quickfix = {
                        -- Position of quickfix window
                        position = "bot",

                        -- Size of quickfix window
                        size     = 10
                    }
                }
            }
        end,
    },
}
