-- Rex configuration for DGYMac.
--
-- Lives here in the dotfiles repo and is symlinked to where Rex looks:
--   ~/.config/rex/init.lua -> ~/.vim/rex/init.lua
--
-- Apply changes with:
--   rex config reload
--
-- Validate without applying:
--   rex config check

local SHELL = "com.superlogical.terminal.shell"

-- Stacked 80/20 split: the shape of `split-window -v -l 20%`.
local function split_layout()
  return rex.layout.vertical(0.8,
    rex.layout.block{ flavor = SHELL },
    rex.layout.block{ flavor = SHELL })
end

-- A new tab that already has the default split.
rex.action{
  name = "new_tab_split",
  title = "New Tab (80/20)",
  description = "Open a tab with a large pane above a 20% pane.",
  category = "Layout",
  run = function()
    return rex.session.new_window{ layout = split_layout() }
  end,
}

-- Session picker: a floating pane running fzf over the server's sessions.
rex.action{
  name = "session_picker",
  title = "Session Picker (fzf)",
  description = "Pick a session with j/k in a floating pane.",
  category = "Navigation",
  run = function(ctx)
    local res, err = rex.session.new_layer{
      bounds = { 0.3, 0.2, 0.4, 0.5 },
      focus = true,
      layout = rex.layout.block{ flavor = SHELL, label = "sessions" },
    }
    if not res then return nil, err end

    local block = res.block_ids and res.block_ids[1]
    if not block then return nil, "no block for the picker" end

    local picker = (os.getenv("HOME") or "") .. "/.vim/rex/session-picker.sh"
    rex.block.call("com.superlogical.terminal", "write", {
      block_id = block,
      data = string.format("clear; '%s' '%s' '%s'\n", picker, ctx.session_id, res.layer_id),
    })
    return { layer_id = res.layer_id, block_id = block }
  end,
}

-- The `m t` layout: session "main" with four tabs, each split 80/20.
rex.action{
  name = "main_layout",
  title = "Main Session (4 tabs)",
  description = "Create the main session: brain, memo, web, play.",
  category = "Layout",
  run = function(ctx)
    local list = rex.call("session.list", {})
    for _, s in ipairs((list and list.sessions) or {}) do
      if s.label == "main" then
        if ctx.client_id then
          rex.client.queue("session.select", { session_id = s.session_id })
        end
        return { session_id = s.session_id, existing = true }
      end
    end

    local windows = {}
    for _, label in ipairs({ "🧠", "🧾", "🌐", "🎮" }) do
      windows[#windows + 1] = { window_label = label, layout = split_layout() }
    end

    local res, err = rex.call("session.create", {
      label = "main",
      initial_windows = windows,
    })
    if not res then return nil, err end

    -- session.create activates the last window. Attach to the new session so
    -- the first tab can be focused, like `select-window -t 🧠`.
    local first = res.initial_windows and res.initial_windows[1]
    if first then
      rex.call("session.attach", { session_id = res.session_id })
      rex.call("session.focus_window", {
        session_id = res.session_id,
        window_id = first.window_id,
      })
    end
    if ctx.client_id then
      rex.client.queue("session.select", {
        session_id = res.session_id,
        window_id = first and first.window_id or nil,
      })
    end
    return res
  end,
}

-- ctrl+hjkl: inside vim/nvim the key is passed through so vim moves its own
-- splits; anywhere else it moves between panes. Returns false so the client
-- hands the key to the focused terminal.
local VIM = { vim = true, nvim = true, gvim = true, vi = true, view = true }

local function vim_focused(ctx)
  local opts = {}
  if ctx and ctx.block_id then opts.block_id = ctx.block_id end
  local proc = rex.block.call("com.superlogical.terminal", "process", opts)
  local fg = proc and proc.foreground
  if not fg then return false end
  local name = (fg.argv0 or fg.name or ""):gsub("^%-", "")
  return VIM[name] == true
end

local function nav_key(key, direction)
  rex.bind(key, function(ctx)
    if vim_focused(ctx) then return false end
    rex.session.focus_direction{ direction = direction }
    return true
  end)
end

nav_key("ctrl+h", "left")
nav_key("ctrl+j", "down")
nav_key("ctrl+k", "up")
nav_key("ctrl+l", "right")

-- Ctrl+/ as the tmux prefix, for muscle memory.
local p = "ctrl+/>"

rex.bind("cmd+t", "new_tab_split")

rex.bind(p .. "c", "new_tab_split")
rex.bind(p .. "m", "main_layout")
rex.bind(p .. "s", "session_picker")
rex.bind(p .. "n", "client.tab.next")
rex.bind(p .. "p", "client.tab.previous")
for i = 1, 5 do
  rex.bind(p .. tostring(i), "client.tab.goto", { index = i })
end

rex.bind(p .. "shift+5", "pane.split", { direction = "right" }) -- %
rex.bind(p .. "shift+'", "pane.split", { direction = "down" })  -- "
rex.bind(p .. "z", "pane.zoom")
rex.bind(p .. "x", "pane.close")
rex.bind(p .. "o", "pane.focus_next")
rex.bind(p .. "space", "pane.balance")

rex.bind(p .. "h", "pane.focus.left")
rex.bind(p .. "j", "pane.focus.down")
rex.bind(p .. "k", "pane.focus.up")
rex.bind(p .. "l", "pane.focus.right")

-- Themes live in the app, not the server, so they are imported with the CLI.
-- Our TokyoNight lives at ~/.vim/rex/themes/tokyonight and is imported with:
--   rex -C DGYMac do client.theme.import path=$HOME/.vim/rex/themes/tokyonight
