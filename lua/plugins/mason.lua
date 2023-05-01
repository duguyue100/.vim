return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        build = ":MasonUpdate", -- :MasonUpdate updates registry contents
        config = function()
            require("mason").setup()
        end,
    },
}
