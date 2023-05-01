return {
    {
        'lervag/vimtex',
        keys = {
            { "<leader>tt", "<cmd>VimtexCompile<cr>", desc = "Compile LaTeX" },
            { "<leader>vv", "<cmd>VimtexView<cr>", desc = "View LaTeX PDF" },
        },
        config = function()
            if vim.fn.has("mac") == 1 then
                vim.g.vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
            end

            vim.g.vimtex_view_general_options = '-r @line @pdf @tex'
            vim.g.vimtex_view_general_options_latexmk = '-r 1'
            vim.g.tex_flavor = "latex"
             
        end,
    },
}
