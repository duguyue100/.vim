return {
    {
        'christoomey/vim-tmux-navigator',
        lazy = false,
        -- Mappings live in config/keymaps.lua so they can fall back to Rex as
        -- well as tmux.
        init = function()
            vim.g.tmux_navigator_no_mappings = 1
        end,
    },
}
