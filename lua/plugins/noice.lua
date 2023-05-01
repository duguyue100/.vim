return {
    {
        'folke/noice.nvim',
        lazy = false,
        dependencies = 'MunifTanjim/nui.nvim',
        config = function()
            require("noice").setup(
            {
                lsp = { 
                    signature = { enabled = false }
                },
                routes = {
                    {
                        view = "notify",
                        filter = { event = "msg_showmode" },
                    },
                },
                cmdline= {
                    format = {
                        cmdline = { pattern = "^:", icon = "🌊 ", lang = "vim" },
                        search_down = { kind = "search", pattern = "^/", icon = "🧐 ", lang = "regex" },
                        search_up = { kind = "search", pattern = "^%?", icon = "🧐 ", lang = "regex" },
                    },
                },
                views = {
                    cmdline_popup = {
                        position = {
                            row = 8,
                            col = "50%",
                        },
                        size = {
                            width = 80,
                            height = "auto",
                        },
                    },
                },
            }
            )
        end,
    },
}
