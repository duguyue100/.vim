return {
    {
        'kyazdani42/nvim-tree.lua',
        event = "VeryLazy",
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'notjedi/nvim-rooter.lua',
        },
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc="Toggle NvimTree" },
        },
        config = function()
            require("nvim-web-devicons").set_icon{
                txt = {
                    icon = "",
                    color = "#7ebae4",
                    name = "txt",
                    cterm_color = "7ebae4",
                },
                ["containerfile"] = {
                    icon = "",
                    color = "#458ee6",
                    cterm_color = "68",
                    name = "Dockerfile",
                },
                ["docker-compose.yml"] = {
                    icon = "",
                    color = "#458ee6",
                    cterm_color = "68",
                    name = "Dockerfile",
                },
                ["docker-compose.yaml"] = {
                    icon = "",
                    color = "#458ee6",
                    cterm_color = "68",
                    name = "Dockerfile",
                },
                [".dockerignore"] = {
                    icon = "",
                    color = "#458ee6",
                    cterm_color = "68",
                    name = "Dockerfile",
                },
                ["dockerfile"] = {
                    icon = "",
                    color = "#458ee6",
                    cterm_color = "68",
                    name = "Dockerfile",
                },
            }

            require('nvim-tree').setup({
                auto_reload_on_write = true,
                create_in_closed_folder = false,
                disable_netrw = false,
                hijack_cursor = true,
                hijack_netrw = true,
                hijack_unnamed_buffer_when_opening = false,
                open_on_tab = false,
                sort_by = "name",
                update_cwd = true,
                reload_on_bufenter = false,
                respect_buf_cwd = true,
                view = {
                    adaptive_size = true,
                    centralize_selection = false,
                    width = 30,
                    hide_root_folder = false,
                    side = "left",
                    preserve_window_proportions = false,
                    number = false,
                    relativenumber = true,
                    signcolumn = "yes",
                    mappings = {
                        custom_only = false,
                        list = {
                            -- user mappings go here
                        },
                    },
                    float = {
                        enable = true,
                        open_win_config = { height = 60 },
                    },
                },
                renderer = {
                    add_trailing = false,
                    group_empty = false,
                    highlight_git = false,
                    full_name = false,
                    highlight_opened_files = "all",
                    root_folder_modifier = ":~",
                    indent_markers = {
                        enable = false,
                        icons = {
                            corner = "└ ",
                            edge = "│ ",
                            item = "│ ",
                            none = "  ",
                        },
                    },
                    icons = {
                        webdev_colors = true,
                        git_placement = "before",
                        padding = " ",
                        symlink_arrow = " ➛ ",
                        show = {
                            file = true,
                            folder = true,
                            folder_arrow = true,
                            git = true,
                        },
                        glyphs = {
                            default = "",
                            symlink = "",
                            folder = {
                                arrow_closed = "",
                                arrow_open = "",
                                default = "",
                                open = "",
                                empty = "",
                                empty_open = "",
                                symlink = "",
                                symlink_open = "",
                            },
                            git = {
                                unstaged = "✗",
                                staged = "✓",
                                unmerged = "",
                                renamed = "➜",
                                untracked = "★",
                                deleted = "",
                                ignored = "◌",
                            },
                        },
                    },
                    special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
                },
                hijack_directories = {
                    enable = true,
                    auto_open = true,
                },
                update_focused_file = {
                    enable = true,
                    update_cwd = true,
                    ignore_list = {},
                },
                system_open = {
                    cmd = "",
                    args = {},
                },
                diagnostics = {
                    enable = false,
                    show_on_dirs = false,
                    icons = {
                        hint = "",
                        info = "",
                        warning = "",
                        error = "",
                    },
                },
                filters = {
                    dotfiles = false,
                    custom = {},
                    exclude = {},
                },
                git = {
                    enable = true,
                    ignore = true,
                    timeout = 400,
                },
                actions = {
                    use_system_clipboard = true,
                    change_dir = {
                        enable = true,
                        global = false,
                        restrict_above_cwd = false,
                    },
                    expand_all = {
                        max_folder_discovery = 300,
                    },
                    open_file = {
                        quit_on_open = false,
                        resize_window = true,
                        window_picker = {
                            enable = true,
                            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                            exclude = {
                                filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                                buftype = { "nofile", "terminal", "help" },
                            },
                        },
                    },
                    remove_file = {
                        close_window = true,
                    },
                },
                trash = {
                    cmd = "gio trash",
                    require_confirm = true,
                },
                live_filter = {
                    prefix = "[FILTER]: ",
                    always_show_folders = true,
                },
                log = {
                    enable = false,
                    truncate = false,
                    types = {
                        all = false,
                        config = false,
                        copy_paste = false,
                        diagnostics = false,
                        git = false,
                        profile = false,
                        watcher = false,
                    },
                },
            })

            require('nvim-rooter').setup {
                rooter_patterns = { '.git', '.hg', '.svn' },
                trigger_patterns = { '*' },
                manual = false,
            }

            vim.cmd('NvimTreeOpen')
        end,
    },
}
