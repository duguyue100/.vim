return {
    {
        'dense-analysis/ale',
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            vim.g.ale_floating_preview = 1
            vim.g.ale_float_window_border = {'│', '─', '╭', '╮', '╯', '╰'}
            vim.g.ale_set_ballons = 1
            vim.g.ale_lint_on_enter = 1
            vim.g.ale_warn_about_trailing_whitespace = 0
            vim.g.ale_fix_on_save = 1
            vim.g.ale_echo_cursor = 0
            -- vim.g.ale_python_flake8_options = '--max-line-length=88 --ignore=E203,E501,W503'
            vim.g.ale_yaml_yamllint_options = '-d "level: error"'
            vim.g.ale_fixers = {
                python = {'ruff', 'ruff_format'},
                cpp = {'clang-format'},
                rust = {'rustfmt'},
                go = {"gopls"},
                typescript = {"biome"},
                yaml = {"yamlfmt"}
            }
            vim.g.ale_linters = {
                python = {'mypy', "jedils", "ruff"},
                rust = {'analyzer'},
                go = {"gopls"},
                typescript = {"biome", "tsserver"},
                yaml = {"yamllint"},
                cpp = {"clangd"},
            }
            vim.g.ale_disable_lsp = 0
            if vim.fn.has("mac") == 1 then
                vim.g.ale_cpp_cc_executable = "/opt/homebrew/bin/g++-15"
                vim.g.ale_cpp_clangd_executable = '/opt/homebrew/opt/llvm/bin/clangd'
                vim.g.ale_cpp_clangd_options = '--query-driver=/opt/homebrew/bin/g++-15'
            end
        end,
    },
}
