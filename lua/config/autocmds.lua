local function augroup(name)
  return vim.api.nvim_create_augroup("dgy_" .. name, { clear = true })
end

-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = augroup "highlight_yank",
  pattern = "*",
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.fn.execute "%s/\\s\\+$//e"
  end,
  group = augroup "remove_trailing_whitespace",
  pattern = "*",
})

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup "last_loc",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto toggle hlsearch
local ns = vim.api.nvim_create_namespace "toggle_hlsearch"
local function toggle_hlsearch(char)
  if vim.fn.mode() == "n" then
    local keys = { "<CR>", "n", "N", "*", "#", "?", "/" }
    local new_hlsearch = vim.tbl_contains(keys, vim.fn.keytrans(char))

    if vim.opt.hlsearch:get() ~= new_hlsearch then
      vim.opt.hlsearch = new_hlsearch
    end
  end
end
vim.on_key(toggle_hlsearch, ns)

-- Kill opencode process on exit (only if tmux pane 2 exists in the current window)
-- TODO: we can remove this if opencode.nvim merged the fix
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    local cmd = table.concat({
      -- Only proceed if pane index 2 exists in the current tmux window
      "tmux list-panes -F '#{pane_index}' | grep -q '^2$'",
      "&&",
      -- Get the shell PID of pane 2, then kill its child processes
      -- (pkill -P is cross-platform; pkill -t tty is broken on macOS)
      "pane_pid=$(tmux display-message -p -t 2 '#{pane_pid}')",
      '&& pkill -TERM -P "$pane_pid"',
      -- Then kill the pane itself
      "&& tmux kill-pane -t 2",
    }, " ")
    vim.fn.jobstart({ "bash", "-c", cmd }, { detach = true })
  end,
})
