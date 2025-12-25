local M = {}
local wezterm = require("wezterm")
local act = wezterm.action

---------------------------------------------------------------
--- 🔧 HELPER FUNCTIONS (Smart Splits)
---------------------------------------------------------------
-- These must be inside this file so the keybinds can use them
local function is_vim(pane)
    local process_info = pane:get_foreground_process_info()
    local process_name = process_info and process_info.name
    return process_name == "nvim" or process_name == "vim"
end

local function split_nav(resize_or_move, key)
    return {
        key = key,
        mods = resize_or_move == "resize" and "META" or "CTRL",
        action = wezterm.action_callback(function(win, pane)
            if is_vim(pane) then
                -- Pass the key to Vim
                win:perform_action({ SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" } }, pane)
            else
                -- Move/Resize WezTerm pane
                if resize_or_move == "resize" then
                    win:perform_action({ AdjustPaneSize = { key, 3 } }, pane)
                else
                    local direction = key == "h" and "Left" or (key == "l" and "Right" or (key == "k" and "Up" or "Down"))
                    win:perform_action({ ActivatePaneDirection = direction }, pane)
                end
            end
        end),
    }
end

---------------------------------------------------------------
--- ⌨️ KEY BINDINGS
---------------------------------------------------------------
function M.create_keybinds()
    return {
        -- 🧠 SMART SPLITS (Ctrl+h/j/k/l)
        split_nav("move", "h"),
        split_nav("move", "j"),
        split_nav("move", "k"),
        split_nav("move", "l"),

        -- 🌟 NEW QUALITY OF LIFE KEYS
        -- Zen Mode (Zoom Pane)
        { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
        -- Toggle Padding (Event defined in main config)
        { key = "p", mods = "LEADER", action = act.EmitEvent("toggle-padding") },
        -- Workspaces
        { key = "w", mods = "LEADER", action = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" } },

        -- 👇 YOUR ORIGINAL KEYS
        { key = "m", mods = "ALT", action = act.ShowLauncherArgs { flags = "FUZZY|LAUNCH_MENU_ITEMS" } },
        { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
        { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
        { key = "f", mods = "CTRL|SHIFT", action = act.Search("CurrentSelectionOrEmptyString") },
        { key = "=", mods = "CTRL", action = act.ResetFontSize },
        { key = "+", mods = "CTRL|SHIFT", action = act.IncreaseFontSize },
        { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
        { key = "n", mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
        { key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
        { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
        { key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
        { key = "\\", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
        { key = "-", mods = "ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
        { key = "w", mods = "ALT", action = act.CloseCurrentPane({ confirm = true }) },
        { key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
        { key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },
        { key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
        { key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },
        { key = "LeftArrow", mods = "ALT", action = act.ActivatePaneDirection("Left") },
        { key = "RightArrow", mods = "ALT", action = act.ActivatePaneDirection("Right") },
        { key = "UpArrow", mods = "ALT", action = act.ActivatePaneDirection("Up") },
        { key = "DownArrow", mods = "ALT", action = act.ActivatePaneDirection("Down") },
        { key = "r", mods = "ALT", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
        { key = "PageUp", mods = "ALT", action = act.ScrollByPage(-1) },
        { key = "PageDown", mods = "ALT", action = act.ScrollByPage(1) },
        { key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) }, 
        { key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) }, 
        { key = "z", mods = "ALT", action = "ReloadConfiguration" },
        { key = "d", mods = "ALT|SHIFT", action = act.ShowDebugOverlay },
        { key = "p", mods = "CTRL|SHIFT", action = act.ActivateCommandPalette }, 
    }
end

M.key_tables = {
    resize_pane = {
        { key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
        { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
        { key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
        { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
        { key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
        { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
        { key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
        { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
        { key = "Escape", action = "PopKeyTable" },
        { key = "Enter", action = "PopKeyTable" },
    },
}

M.mouse_bindings = {
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "NONE",
        action = act.CompleteSelection("PrimarySelection"),
    },
    {
        event = { Up = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = act.CompleteSelection("Clipboard"),
    },
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = act.OpenLinkAtMouseCursor,
    },
}

return M
