local wezterm = require("wezterm")
local act = wezterm.action
local keybinds = require("keybinds")

---------------------------------------------------------------
--- 🧠 INTELLIGENT PADDING (Auto-Resize)
---------------------------------------------------------------
-- This event runs every time the screen updates or you switch panes
wezterm.on('update-status', function(window, pane)
    -- Get the current process name (e.g., "nvim", "vim", "wslhost.exe")
    local process = pane:get_foreground_process_name()
    -- On Windows, it might look like "C:\...\nvim.exe", so we search for "vim"
    local is_vim = process:find("nvim") or process:find("vim")

    local overrides = window:get_config_overrides() or {}
    
    if is_vim then
        -- If we are in Vim, and padding is NOT zero, kill it
        if not overrides.window_padding or overrides.window_padding.left ~= 0 then
            overrides.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
            window:set_config_overrides(overrides)
        end
    else
        -- If we are NOT in Vim, and padding IS zero, restore defaults
        if overrides.window_padding and overrides.window_padding.left == 0 then
            overrides.window_padding = nil -- setting to nil restores the config defaults
            window:set_config_overrides(overrides)
        end
    end
end)

---------------------------------------------------------------
--- 🎨 THEME & TABS (Stabilized Chrome Style)
---------------------------------------------------------------
local body_bg = "#0b0f1a"
local bar_bg = "#000000"
local active_fg = "#7aa2f7"
local inactive_fg = "#565f89"
local hover_fg = "#89b4fa"

local function get_icon(process)
    local icons = {
        ["docker"] = "", ["vim"] = "", ["nvim"] = "",
        ["python"] = "", ["node"] = "", ["zsh"] = "",
        ["bash"] = "", ["htop"] = "", ["git"] = "",
        ["powershell.exe"] = "", ["cmd.exe"] = "",
        ["wsl.exe"] = "", ["wslhost.exe"] = "",
    }
    -- Robust matching to handle full paths
    local name = process:match("([^/\\]+)$") or process
    -- Remove .exe extension if present for matching
    name = name:gsub("%.exe$", "")
    return icons[name] or ""
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local bg, fg, icon, title
    icon = get_icon(tab.active_pane.foreground_process_name)
    title = tab.active_pane.title
    if #title > 20 then title = wezterm.truncate_right(title, 20) .. ".." end

    -- Active Tab (Folder Shape)
    if tab.is_active then
        return {
            { Background = { Color = bar_bg } }, { Foreground = { Color = body_bg } }, { Text = "\u{e0b6}" },
            { Background = { Color = body_bg } }, { Foreground = { Color = active_fg } }, { Attribute = { Intensity = "Bold" } }, { Text = icon .. " " .. title },
            { Background = { Color = bar_bg } }, { Foreground = { Color = body_bg } }, { Text = "\u{e0b4}" },
            { Background = { Color = bar_bg } }, { Text = " " },
        }
    end

    -- Inactive Tab (Stabilized)
    if hover then fg = hover_fg else fg = inactive_fg end
    return {
        { Background = { Color = bar_bg } }, { Text = " " },
        { Background = { Color = bar_bg } }, { Foreground = { Color = fg } }, { Text = icon .. " " .. title },
        { Background = { Color = bar_bg } }, { Text = " " },
        { Background = { Color = bar_bg } }, { Text = " " },
    }
end)

---------------------------------------------------------------
--- ⚙️ MAIN CONFIG
---------------------------------------------------------------
local config = {
    default_prog = { "wsl.exe" },
    check_for_updates = false,
    color_scheme = "Catppuccin Mocha",
    font = wezterm.font("FiraCode Nerd Font", { weight = "Medium" }),
    font_size = 12.0,
    line_height = 1.3,
    
    -- Visuals
    window_background_opacity = 0.85,
    win32_system_backdrop = "Acrylic",
    window_decorations = "RESIZE",
    
    -- DEFAULT PADDING (Used when NOT in Neovim)
    window_padding = { left = 20, right = 20, top = 10, bottom = 10 },
    
    -- Dim Inactive Panes
    inactive_pane_hsb = { saturation = 0.9, brightness = 0.5 },

    -- Tabs
    use_fancy_tab_bar = false, 
    tab_bar_at_bottom = false,
    show_new_tab_button_in_tab_bar = true,
    tab_max_width = 50,
    
    colors = {
        background = body_bg, 
        tab_bar = {
            background = bar_bg,
            new_tab = { bg_color = bar_bg, fg_color = inactive_fg },
            new_tab_hover = { bg_color = bar_bg, fg_color = hover_fg },
        },
    },

    -- Menus
    launch_menu = {
        { label = "PowerShell Core", args = { "pwsh.exe" } },
        { label = "WSL", args = { "wsl.exe" } },
        { label = "Git Bash", args = { "C:\\Program Files\\Git\\bin\\bash.exe", "-l" } },
    },
    
    -- Keys imported from keybinds.lua
    disable_default_key_bindings = true,
    leader = { key = "Space", mods = "CTRL|SHIFT" },
    keys = keybinds.create_keybinds(),
    key_tables = keybinds.key_tables,
    mouse_bindings = keybinds.mouse_bindings,
}

return config
