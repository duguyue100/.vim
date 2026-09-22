local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- Leader keymaps
map("n", "<leader>w", "<cmd>w!<cr>", { desc = "Fast write", silent = true })
map("n", "<leader>q", "<cmd>qall<cr>", { desc = "Fast quit" })
map({ "n", "x" }, "<leader>d", '"_d', { desc = "Actual delete" })

-- Telescope keymaps

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files", silent = true })
map("n", "<leader>fg", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", { desc = "Live grep", silent = true })
map("n", "<leader>fp", "<cmd>Telescope git_files<cr>", { desc = "Git files", silent = true })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers", silent = true })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags", silent = true })

-- ALE
map("n", "<leader>gd", "<cmd>ALEGoToDefinition<cr>", { desc = "Go to definition", silent = true })
map("n", "<leader>gh", "<cmd>ALEHover<cr>", { desc = "Hover information", silent = true })

-- BufferLine
map("n", "<leader>bn", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer", silent = true })
map("n", "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer", silent = true })
map("n", "<leader>bd", "<cmd>Bdelete<cr>", { desc = "Delete buffer", silent = true })
map("n", "mn", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer right", silent = true })
map("n", "mp", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer left", silent = true })

-- New line below
map("n", "<cr>", "o<Esc>", { desc = "New line below", silent = true })

-- Use space as search
map("n", "<space>", "/", { desc = "Search", silent = true })

-- Persistence keymaps
map("n", "<leader>ss", "<cmd>lua require('persistence').load()<cr>", { desc = "Load session", silent = true })
map("n", "<leader>sl", "<cmd>lua require('persistence').load({ last = true })<cr>", { desc = "Load last session", silent = true })
map("n", "<leader>sd", "<cmd>lua require('persistence').stop()<cr>", { desc = "Stop saving on exit", silent = true })

-- OpenCode keymap
-- map({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
map({ "n", "x" }, "<leader>oa", function() require("opencode").ask_multiline("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
map({ "n", "x" }, "<leader>os", function() require("opencode").select() end, { desc = "Execute opencode action…" })
-- Open (or re-open) the tmux opencode pane, attached to `session` if given.
-- Reuses pane 2 when it exists so the pane index stays stable.
local function open_opencode(session)
    local cmd = session and ("opencode --session " .. session) or "opencode"
    local quoted = vim.fn.shellescape(cmd)
    local script = table.concat({
        "if tmux list-panes -F '#{pane_index}' | grep -q '^2$';",
        "tmux respawn-pane -k -t 2 " .. quoted .. ";",
        "else;",
        "tmux split-window -h -t 1 -d " .. quoted .. ";",
        "end",
    }, " ")
    vim.fn.system({ "fish", "-c", script })
end

-- Ask the server for this project's sessions, newest first.
local function list_sessions()
    local raw = vim.fn.system({
        "opencode", "api", "get", "/api/session",
        "--param", "directory=" .. vim.fn.getcwd(),
        "--param", "order=desc",
        "--param", "parentID=null",
    })
    local ok, decoded = pcall(vim.fn.json_decode, raw)
    return (ok and decoded and decoded.data) or {}
end

-- Start a new session and make it the target `<leader>oa` sends to.
map("n", "<leader>oc", function()
    local raw = vim.fn.system({
        "opencode", "api", "post", "/api/session",
        "--data", vim.fn.json_encode({ location = { directory = vim.fn.getcwd() } }),
    })
    local ok, decoded = pcall(vim.fn.json_decode, raw)
    local session = ok and decoded and decoded.data and decoded.data.id or nil
    _G.opencode_target = session
    open_opencode(session)
end, { desc = "Open opencode in tmux (new session)" })

-- Pick an existing session; it becomes the `<leader>oa` target and the TUI
-- re-opens attached to it. This is how you switch sessions (the TUI cannot
-- report which tab is focused back to Neovim).
map("n", "<leader>ol", function()
    local sessions = list_sessions()
    if #sessions == 0 then
        vim.notify("No opencode sessions for this project", vim.log.levels.WARN, { title = "opencode" })
        return
    end
    local items = {}
    for _, session in ipairs(sessions) do
        table.insert(items, {
            id = session.id,
            label = string.format("%s  (%s)", session.title or "(untitled)", session.id:sub(1, 12)),
        })
    end
    vim.ui.select(items, {
        prompt = "OpenCode session:",
        format_item = function(item) return item.label end,
    }, function(choice)
        if not choice then return end
        _G.opencode_target = choice.id
        open_opencode(choice.id)
    end)
end, { desc = "Switch opencode session" })
local function kill_opencode()
    local cmd = table.concat({
        "tmux list-panes -F '#{pane_index}' | grep -q '^2$'",
        "&&",
        "pane_pid=$(tmux display-message -p -t 2 '#{pane_pid}')",
        '&& pkill -TERM -P "$pane_pid"',
        "&& tmux kill-pane -t 2",
    }, " ")
    vim.fn.jobstart({ "bash", "-c", cmd }, { detach = true })
end
map("n", "<leader>ok", kill_opencode, { desc = "Kill opencode pane" })

-- Competitive Programming keymap
map("n", "<leader>ct", function()
    local path = vim.fn.expand("~/.vim/cp_templates/cpp.cpp")
    if vim.fn.filereadable(path) == 1 then
        local lines = vim.fn.readfile(path)
        local row = vim.api.nvim_win_get_cursor(0)[1]
        vim.api.nvim_buf_set_lines(0, row - 1, row, false, lines)
    else
        vim.notify("Template not found at: " .. path, vim.log.levels.ERROR)
    end
end, { desc = "Insert CP Template" })

map("n", "<leader>cr", "<cmd>CompetiTest run<cr>", { desc = "Run tests", silent = true })
map("n", "<leader>cd", "<cmd>CompetiTest receive testcases<cr>", { desc = "Download test cases", silent = true })
map("n", "<leader>ca", "<cmd>CompetiTest add_testcase<cr>", { desc = "Download test cases", silent = true })

map("n", "<leader>cx", function()
    -- 1. Get the full path and name details of the currently active buffer
    local current_file = vim.api.nvim_buf_get_name(0)

    -- Safety check: Ensure it's actually a C++ file
    if current_file == "" or vim.bo.filetype ~= "cpp" then
        vim.notify("Not a valid C++ buffer to clean!", vim.log.levels.WARN)
        return
    end

    -- 2. Extract the base path and problem name (e.g., /path/to/faktor)
    local base_path = current_file:sub(1, -5)
    local problem_name = vim.fn.fnamemodify(current_file, ":t:r")
    local directory = vim.fn.fnamemodify(current_file, ":h")

    -- 3. Construct a shell command that targets ONLY this problem's clutter
    -- It deletes the binary ('faktor') and any inputs/outputs ('faktor_input*.txt')
    local cmd = string.format(
        "rm -f '%s' '%s'_input*.txt '%s'_output*.txt",
        base_path, base_path, base_path
    )

    -- 4. Execute asynchronously via Neovim's jobstart so it doesn't freeze your UI
    vim.fn.jobstart(cmd, {
        on_exit = function(_, exit_code)
            if exit_code == 0 then
                vim.notify("Cleaned up " .. problem_name .. " binaries and text files!", vim.log.levels.INFO)
            else
                vim.notify("Cleanup failed for " .. problem_name, vim.log.levels.ERROR)
            end
        end
    })
end, { desc = "Clean up current CP text files and binary" })
