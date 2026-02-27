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

-- Copilot keymaps
map("i", "<C-f>", "<Plug>(copilot-next)", { desc="Copilot next suggestion", silent = true })
map("i", "<C-b>", "<Plug>(copilot-previous)", { desc="Copilot previous suggestion", silent = true })

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
map({ "n", "x" }, "<leader>oc", function() vim.fn.system({"fish", "-c", "tmux split-window -h -t 1 -d && tmux send-keys -t 2 'opencode --port 8192' Enter"}) end, { desc = "Open opencode in tmux" })
local function kill_opencode()
    vim.fn.jobstart({ "pkill", "-f", "opencode --port" }, { detach = true })
    local cmd = "tmux list-panes -F '#P' | grep -q '^2$' && tmux kill-pane -t 2"
    vim.fn.jobstart({ "bash", "-c", cmd }, { detach = true })
end
map("n", "<leader>ok", kill_opencode, { desc = "Kill opencode pane" })
