return {
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        config = function()
            local dashboard = require'alpha.themes.dashboard'

            dashboard.section.header.val = {
            [[           _____                    _____                _____          ]],
            [[          /\    \                  /\    \              |\    \         ]],
            [[         /::\    \                /::\    \             |:\____\        ]],
            [[        /::::\    \              /::::\    \            |::|   |        ]],
            [[       /::::::\    \            /::::::\    \           |::|   |        ]],
            [[      /:::/\:::\    \          /:::/\:::\    \          |::|   |        ]],
            [[     /:::/  \:::\    \        /:::/  \:::\    \         |::|   |        ]],
            [[    /:::/    \:::\    \      /:::/    \:::\    \        |::|   |        ]],
            [[   /:::/    / \:::\    \    /:::/    / \:::\    \       |::|___|______  ]],
            [[  /:::/    /   \:::\ ___\  /:::/    /   \:::\ ___\      /::::::::\    \ ]],
            [[ /:::/____/     \:::|    |/:::/____/  ___\:::|    |    /::::::::::\____\]],
            [[ \:::\    \     /:::|____|\:::\    \ /\  /:::|____|   /:::/~~~~/~~      ]],
            [[  \:::\    \   /:::/    /  \:::\    /::\ \::/    /   /:::/    /         ]],
            [[   \:::\    \ /:::/    /    \:::\   \:::\ \/____/   /:::/    /          ]],
            [[    \:::\    /:::/    /      \:::\   \:::\____\    /:::/    /           ]],
            [[     \:::\  /:::/    /        \:::\  /:::/    /    \::/    /            ]],
            [[      \:::\/:::/    /          \:::\/:::/    /      \/____/             ]],
            [[       \::::::/    /            \::::::/    /                           ]],
            [[        \::::/    /              \::::/    /                            ]],
            [[         \::/____/                \::/____/                             ]],
            [[          ~~                                                            ]],
            }

            dashboard.section.buttons.val = {
                dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("SPC f f", "  Find file", ":Telescope find_files<CR>"),
                dashboard.button("SPC f h", "  Recently opened files", ":Telescope oldfiles<CR>"),
                dashboard.button("SPC f g", "  Find word", ":Telescope oldfiles<CR>"),
                dashboard.button("SPC f r", "  Frecency/MRU"),
            }

            require'alpha'.setup(dashboard.config)
        end,
    },
}
