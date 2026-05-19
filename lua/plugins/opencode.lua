return {
    "NickvanDyke/opencode.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        -- Recommended for `ask()` and `select()`.
        -- Required for `snacks` provider.
        ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
        { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    init = function()
        -- Inject the ask_multiline UI module so it is available when the plugin
        -- calls require("opencode.ui.ask_multiline"). This lets us use the
        -- upstream NickvanDyke/opencode.nvim without maintaining a fork.
        package.preload["opencode.ui.ask_multiline"] = function()
            local M = {}

            ---Open a centered floating window for multiline prompt input.
            ---
            ---Keymaps:
            --- - `<CR>` (insert/normal): Submit the prompt.
            --- - `<Esc>` / `q` (normal): Cancel and close the window.
            ---
            ---@param default? string Text to pre-fill the input with.
            ---@param context opencode.Context
            ---@return Promise<string> input
            function M.ask_multiline(default, context)
                local Promise = require("opencode.promise")

                return require("opencode.server.discovery")
                    .get()
                    :next(function(server) ---@param server opencode.cli.server.Server
                        return Promise.new(function(resolve, reject)
                            local config = require("opencode.config").opts.ask_multiline or {}
                            local win_width_frac  = config.width  or 0.5
                            local win_height_frac = config.height or 0.2
                            local border          = config.border or "rounded"
                            local title           = config.title  or " 󰚩 Ask opencode "

                            -- Calculate centered window dimensions from config ratios
                            local editor_width  = vim.o.columns
                            local editor_height = vim.o.lines
                            local win_width     = math.floor(editor_width  * win_width_frac)
                            local win_height    = math.floor(editor_height * win_height_frac)
                            local row = math.floor((editor_height - win_height) / 2)
                            local col = math.floor((editor_width  - win_width)  / 2)

                            -- Create a scratch buffer
                            local buf = vim.api.nvim_create_buf(false, true)
                            vim.bo[buf].buftype  = "nofile"
                            vim.bo[buf].bufhidden = "wipe"
                            vim.bo[buf].filetype = "opencode_ask"

                            -- Pre-fill default text if provided
                            local default_lines = nil
                            if default and default ~= "" then
                                default_lines = vim.split(default, "\n", { plain = true })
                                vim.api.nvim_buf_set_lines(buf, 0, -1, false, default_lines)
                            end

                            local footer = " <CR> submit  <Esc> cancel "

                            -- Open the floating window
                            local win = vim.api.nvim_open_win(buf, true, {
                                relative   = "editor",
                                width      = win_width,
                                height     = win_height,
                                row        = row,
                                col        = col,
                                style      = "minimal",
                                border     = border,
                                title      = title,
                                title_pos  = "center",
                                footer     = footer,
                                footer_pos = "center",
                            })

                            -- Enable text wrapping at word boundaries
                            vim.wo[win].wrap      = true
                            vim.wo[win].linebreak = true

                            -- Start the in-process LSP for context/subagent completions
                            pcall(vim.lsp.start, require("opencode.ui.ask.cmp"), { bufnr = buf })

                            -- Enter insert mode, positioned after any pre-filled default text
                            if default_lines then
                                local last_line = #default_lines
                                local last_col  = #default_lines[last_line]
                                vim.api.nvim_win_set_cursor(win, { last_line, last_col })
                                vim.cmd("startinsert!")
                            else
                                vim.cmd("startinsert")
                            end

                            local closed = false
                            local function close_win()
                                if closed then return end
                                closed = true
                                vim.cmd("stopinsert")
                                if vim.api.nvim_win_is_valid(win) then
                                    vim.api.nvim_win_close(win, true)
                                end
                            end

                            -- Submit: gather all lines, join with newlines, resolve the promise
                            local function submit()
                                local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                                local text  = table.concat(lines, "\n")
                                close_win()
                                if text == "" then
                                    reject()
                                else
                                    resolve(text)
                                end
                            end

                            -- Cancel: close the window and reject the promise
                            local function cancel()
                                close_win()
                                context:resume()
                                reject()
                            end

                            -- <CR> submits in both insert and normal mode
                            vim.keymap.set({ "n", "i" }, "<CR>", submit, { buffer = buf, desc = "Submit prompt" })

                            -- Cancel keymaps
                            vim.keymap.set("n", "<Esc>", cancel, { buffer = buf, desc = "Cancel prompt" })
                            vim.keymap.set("n", "q",     cancel, { buffer = buf, desc = "Cancel prompt" })

                            -- Handle the buffer being closed externally (e.g. :q)
                            vim.api.nvim_create_autocmd("BufWipeout", {
                                buffer   = buf,
                                once     = true,
                                callback = function()
                                    if not closed then
                                        closed = true
                                        context:resume()
                                        reject()
                                    end
                                end,
                            })
                        end)
                    end)
                    :catch(function(err)
                        context:resume()
                        return Promise.reject(err)
                    end)
            end

            return M
        end
    end,
    config = function()
        ---@type opencode.Opts
        vim.g.opencode_opts = {
            ask_multiline = {
                width  = 0.5,
                height = 0.2,
                border = "rounded",
                title  = " 󰚩 Ask opencode ",
            },
        }

        -- Required for `opts.events.reload`.
        vim.o.autoread = true

        -- Expose ask_multiline on the public API (the upstream plugin does not
        -- include this command; we inject it here so keymaps work unchanged).
        local opencode = require("opencode")
        opencode.ask_multiline = function(default, opts)
            opts         = opts or {}
            opts.context = opts.context or require("opencode.context").new()

            return require("opencode.ui.ask_multiline")
                .ask_multiline(default, opts.context)
                :next(function(input) ---@param input string
                    opts.context:clear()
                    return require("opencode.api.prompt").prompt(input, opts)
                end)
                :catch(function(err)
                    if err then
                        vim.notify(err, vim.log.levels.ERROR, { title = "opencode" })
                    end
                end)
        end
    end,
}
