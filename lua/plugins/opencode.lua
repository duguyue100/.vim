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
            ---@param server opencode.server.Server
            ---@param context opencode.context.Context
            ---@return Promise<string> input
            function M.ask_multiline(default, server, context)
                local Promise = require("opencode.promise")

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
                end):catch(function(err)
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
            -- server = {
            --     url = "http://localhost:8192",
            -- },
            ask_multiline = {
                width  = 0.5,
                height = 0.2,
                border = "rounded",
                title  = " 󰚩 Ask opencode ",
            },
        }

        -- Required for `opts.events.reload`.
        vim.o.autoread = true

        -- Neovim owns the session target (`_G.opencode_target`, set by
        -- `<leader>oc` and `<leader>ol`). The TUI cannot report which tab is
        -- focused, so don't guess: use the recorded target while it still
        -- exists, otherwise fall back to the newest session.
        local Server = require("opencode.server")
        local Promise = require("opencode.promise")
        Server.resolve_session = function(self)
            return self:get_sessions():next(function(sessions)
                local target_id = _G.opencode_target
                if target_id then
                    for _, session in ipairs(sessions) do
                        if session.id == target_id and not (session.time and session.time.archived) then
                            return Promise.resolve(session)
                        end
                    end
                end

                for _, session in ipairs(sessions) do
                    if not (session.time and session.time.archived) then
                        return Promise.resolve(session)
                    end
                end

                return Promise.reject("No OpenCode session found for `" .. vim.fn.getcwd() .. "`.")
            end)
        end

        -- `oa` delivery helpers. A fresh TUI session is a client-side draft with
        -- no id, so the first prompt after `<leader>oc` is pasted into the TUI
        -- pane and whatever session the TUI creates becomes the target. That
        -- avoids materializing an empty session just by opening `oc`.
        local function has_opencode_pane()
            vim.fn.system("tmux list-panes -F '#{pane_index}' | grep -q '^2$'")
            return vim.v.shell_error == 0
        end

        local function paste_into_pane(text)
            if not has_opencode_pane() then return false end
            vim.fn.system({ "tmux", "set-buffer", "-b", "opencode-oa", text })
            if vim.v.shell_error ~= 0 then return false end
            vim.fn.system({ "tmux", "paste-buffer", "-p", "-d", "-b", "opencode-oa", "-t", "2" })
            if vim.v.shell_error ~= 0 then return false end
            vim.fn.system({ "tmux", "send-keys", "-t", "2", "Enter" })
            return vim.v.shell_error == 0
        end

        local function create_session(server)
            return server
                :request("/api/session", "POST", { location = { directory = vim.fn.getcwd() } })
                :next(function(response)
                    local session = response and response.data
                    if not (session and session.id) then
                        return Promise.reject("Failed to create an OpenCode session")
                    end
                    return Promise.resolve(session)
                end)
        end

        -- Poll for the session the TUI created from the pasted prompt.
        local function adopt_tui_session(server, since)
            local attempts = 0
            local function attempt()
                return server:get_sessions():next(function(sessions)
                    for _, session in ipairs(sessions) do
                        local created = session.time and session.time.created
                        if created and created >= since then
                            return Promise.resolve(session)
                        end
                    end
                    attempts = attempts + 1
                    if attempts >= 15 then
                        return Promise.reject("Timed out waiting for the TUI to create a session")
                    end
                    return Promise.new(function(resolve, reject)
                        vim.defer_fn(function()
                            attempt():next(resolve):catch(reject)
                        end, 300)
                    end)
                end)
            end
            return attempt()
        end

        -- Expose ask_multiline on the public API (the upstream plugin does not
        -- include this command; we inject it here so keymaps work unchanged).
        local opencode = require("opencode")
        opencode.ask_multiline = function(default, opts)
            opts = opts or {}

            -- Mirror the upstream `opencode.ask()` flow: resolve the server
            -- first, then thread `server` + `context` through the UI and the
            -- prompt API (both now require the server argument).
            return require("opencode.server.discovery")
                .get()
                :next(function(server) ---@param server opencode.server.Server
                    local context = opts.context or require("opencode.context").new(server)
                    return require("opencode.ui.ask_multiline")
                        .ask_multiline(default, server, context)
                        :next(function(input) ---@param input string
                            local pending = _G.opencode_pending

                            -- First prompt after `<leader>oc`: let the TUI
                            -- materialize its own draft, so no empty session is
                            -- created before you actually send something.
                            if pending and not _G.opencode_target then
                                _G.opencode_pending = nil
                                local plaintext = context:render(input).output:plaintext()
                                if paste_into_pane(plaintext) then
                                    return adopt_tui_session(server, (pending.since or 0) - 1000)
                                        :next(function(session)
                                            _G.opencode_target = session.id
                                            context:clear()
                                        end)
                                        :catch(function(err)
                                            context:resume()
                                            return Promise.reject(err)
                                        end)
                                end
                                -- No TUI pane to paste into: fall back to
                                -- creating the session through the API.
                                return create_session(server):next(function(session)
                                    _G.opencode_target = session.id
                                    return require("opencode.api.prompt").prompt(input, context)
                                end)
                            end

                            return require("opencode.api.prompt").prompt(input, context)
                        end)
                end)
                :catch(function(err)
                    if err then
                        vim.notify(err, vim.log.levels.ERROR, { title = "opencode" })
                    end
                end)
        end
    end,
}
