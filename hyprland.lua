-- Hyprland 0.55+ Lua configuration.

local terminal = "ghostty"
local launcher = "rofi -show drun -theme ~/.config/rofi/style.rasi"
local mainMod = "SUPER"
local resizeMod = mainMod .. " + ALT"

hl.monitor({
    output = "",
    mode = "2560x1080@60",
    position = "auto",
    scale = 1,
})

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("~/.local/bin/set-wallpaper")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 8,
        border_size = 2,
        col = {
            active_border = { colors = { "rgba(dc8a78ff)", "rgba(8839efff)" }, angle = 45 },
            inactive_border = { colors = { "rgba(7287fdcc)", "rgba(179299cc)" }, angle = 45 },
        },
        layout = "dwindle",
    },
    decoration = {
        rounding = 10,
        active_opacity = 0.96,
        inactive_opacity = 0.90,
        blur = {
            enabled = true,
            size = 8,
            passes = 3,
        },
    },
    animations = {
        enabled = true,
    },
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
        },
    },
    dwindle = {
        preserve_split = true,
    },
})

hl.curve("ease", { type = "bezier", points = {{0.05, 0.9}, {0.1, 1.05}} })
hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "ease" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "ease", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "ease" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "ease" })

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + TAB", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.window.cycle_next({ next = false }))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))

-- Resize floating windows with the keyboard or mouse.
hl.bind(resizeMod .. " + LEFT", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(resizeMod .. " + RIGHT", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
hl.bind(resizeMod .. " + UP", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
hl.bind(resizeMod .. " + DOWN", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

for i = 1, 5 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.window_rule({
    name = "calculator-float",
    match = { class = "^(org.gnome.Calculator)$" },
    float = true,
})

hl.window_rule({
    name = "pavucontrol-float",
    match = { class = "^(pavucontrol)$" },
    float = true,
})

hl.window_rule({
    name = "all-windows-float",
    match = { class = ".*" },
    float = true,
})
