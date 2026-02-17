local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local is_WIN_platform = (wezterm.target_triple:find("windows") ~= nil)

-- the default shell(compatible)
if is_WIN_platform then
    -- Windows :nu → pwsh → powershell → cmd
    local function command_exists(cmd)
        local success, stdout, stderr =
            wezterm.run_child_process({"where", cmd})
        return success and stdout and stdout ~= ""
    end
    if command_exists("nu.exe") then
        config.default_prog = {'nu.exe', '-l'}
    elseif command_exists("powershell.exe") then
        config.default_prog = {'powershell.exe', '-NoLogo'}
    else
        config.default_prog = {'cmd.exe'}
    end
else
    -- Unix :nu → bash → sh
    local function command_exists(cmd)
        local success, stdout, stderr = wezterm.run_child_process({
            "sh", "-c", "command -v " .. cmd
        })
        return success and stdout and stdout ~= ""
    end
    if command_exists("nu") then
        config.default_prog = {'nu', '-i'}
    elseif command_exists("bash") then
        config.default_prog = {'bash', '-i'}
    else
        config.default_prog = {'sh', '-i'}
    end
end

-- font and font size
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 12

-- color scheme , window
config.color_scheme = 'Rosé Pine Moon (Gogh)'
config.initial_cols = 100
config.initial_rows = 29
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
-- config.window_frame = {
--     active_titlebar_bg = "#232136",
--     inactive_titlebar_bg = "#232136"
-- }
-- config.integrated_title_button_alignment = "Right"
-- config.integrated_title_button_style = "Windows"
-- config.integrated_title_buttons = {"Hide", "Maximize", "Close"}
config.adjust_window_size_when_changing_font_size = false
-- config.window_close_confirmation = 'NeverPrompt'

-- tab bar
config.use_fancy_tab_bar = false
config.enable_tab_bar = true
config.show_tab_index_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.colors = {
  tab_bar = {
    background = '#232136',

    active_tab = {
      bg_color = '#232136',
      fg_color = '#c0c0c0',
      -- "Half", "Normal" or "Bold" 
      intensity = 'Normal',
      italic = false,
    },

    inactive_tab = {
      bg_color = '#1b1032',
      fg_color = '#808080',
    },
    inactive_tab_hover = {
      bg_color = '#3b3052',
      fg_color = '#909090',
      italic = true,
    },
    new_tab = {
      bg_color = '#1b1032',
      fg_color = '#808080',
    },
    new_tab_hover = {
      bg_color = '#3b3052',
      fg_color = '#909090',
      italic = true,
    },
  },
}

-- performance
config.max_fps = 120
config.front_end = 'WebGpu'
config.webgpu_power_preference = 'HighPerformance'

-- launch menu
launch_menu_win = {
    {label = "Bash", args = {"bash", "-l"}},
    {
        label = "PowerShell",
        args = {"powershell.exe", "-NoLogo"}
    },
    {
        label = "SSH: your_ssh",
        args = {"ssh", "-p 22", "your_ssh@your_ssh_ip"}
    },
    {
        label = "WSL: Ubuntu-24.04",
        args = {"wsl.exe", "-d", "Ubuntu-24.04"}
    }
}
config.launch_menu = launch_menu_win

-- key bindings
config.disable_default_key_bindings = true
config.leader = {key = "e", mods = "CTRL", timeout_milliseconds = 1500}
config.keys = {
    -- F11:切换全屏
    {key = 'F11', mods = 'NONE', action = wezterm.action.ToggleFullScreen},
    -- Leader + m:隐藏窗口
    {key = 'm', mods = 'LEADER', action = wezterm.action.Hide},
    -- Leader + n:新建标签页
    {key = 'n', mods = 'LEADER', action = wezterm.action.SpawnTab('CurrentPaneDomain')},
    -- Leader + w:关闭当前标签页(不确认)
    {key = 'w', mods = 'LEADER', action = wezterm.action.CloseCurrentTab({confirm = false})},
    -- Leader + Tab:切换到下一个标签页
    {key = 'Tab', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(1)},
    -- Leader + \\:水平分割
    {key = '\\', mods = 'LEADER', action = wezterm.action.SplitHorizontal({domain = 'CurrentPaneDomain'})},
    -- Leader + -:垂直分割
    {key = '-', mods = 'LEADER', action = wezterm.action.SplitVertical({domain = 'CurrentPaneDomain'})},
    -- Leader + 方向键:在窗格之间移动
    {key = "h",  mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Left')},
    {key = "j",  mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Down')},
    {key = "k",    mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Up')},
    {key = "l", mods = 'LEADER',    action = wezterm.action.ActivatePaneDirection('Right')},
    -- Ctrl + Shift + 方向键:调整窗格大小
    {key = "LeftArrow",  mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize({'Left', 5})},
    {key = "DownArrow",  mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize({'Down', 5})},
    {key = "UpArrow",    mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize({'Up', 5})},
    {key = "RightArrow", mods = 'CTRL|SHIFT', action = wezterm.action.AdjustPaneSize({'Right', 5})},
    -- Ctrl + Shift + W:关闭当前窗格(带确认)
    {key = 'x', mods = 'LEADER', action = wezterm.action.CloseCurrentPane({confirm = true})},
    -- Leader + t:切换标签栏显示 / 隐藏
    {key = "t", mods = 'LEADER', action = wezterm.action.EmitEvent('toggle-tab-bar')},
        -- Leader + f:搜索
    {key = 'f', mods = 'LEADER', action = wezterm.action.Search('CurrentSelectionOrEmptyString')},
    -- Leader + p:打开 Launcher(类似 VS Code 命令面板)
    {key = 'p', mods = 'LEADER', action = wezterm.action.ShowLauncher},
    -- Leader + k:清除滚动缓冲区
    {key = 'c', mods = 'LEADER', action = wezterm.action.ClearScrollback('ScrollbackAndViewport')},
    -- F1:帮助 / 命令面板
    {key = "F1", action = wezterm.action.ShowLauncherArgs {
        flags = "FUZZY|LAUNCH_MENU_ITEMS|DOMAINS|KEY_ASSIGNMENTS"
    }},
    -- Leader + Home/End:快速滚动到顶部/底部
    {key = 'Home', mods = 'LEADER', action = wezterm.action.ScrollToTop},
    {key = 'End',  mods = 'LEADER', action = wezterm.action.ScrollToBottom},
    {key = 'c',mods = 'CTRL|SHIFT',action = wezterm.action.CompleteSelection('Clipboard')},
    {key = 'v', mods = 'CTRL|SHIFT',action = wezterm.action.PasteFrom('Clipboard')},

    {key = 'f',mods = 'CTRL',action = wezterm.action.SendKey { key = 'RightArrow' }},
}
wezterm.on('toggle-tab-bar', function(window, pane)
    local overrides = window:get_config_overrides() or {}
    if overrides.enable_tab_bar == nil then
        overrides.enable_tab_bar = false
    else
        overrides.enable_tab_bar = not overrides.enable_tab_bar
    end
    window:set_config_overrides(overrides)
end)

-- mouse bindings
config.disable_default_mouse_bindings = false
config.mouse_bindings = {
    {  -- 左键选择文本并复制到剪贴板
        event = {Up = {streak = 1, button = 'Left'}},
        mods = 'NONE',
        action = wezterm.action.CompleteSelection('Clipboard')
    },
    {  -- 右键粘贴剪贴板内容
        event = {Down = {streak = 1, button = 'Right'}},
        mods = 'NONE',
        action = wezterm.action.PasteFrom('Clipboard')
    },
    {
        -- 按住 Ctrl+Alt 拖动左键移动窗口
        event = {Drag = {streak = 1, button = 'Left'}},
        mods = 'CTRL|ALT',
        action = wezterm.action.StartWindowDrag
    },
    {
        -- 按住 Ctrl 点击左键打开超链接
        event = {Up = {streak = 1, button = 'Left'}},
        mods = 'CTRL',
        action = wezterm.action.OpenLinkAtMouseCursor
    },
}

-- misc
config.enable_scroll_bar = true
-- config.scrollback_lines = 20000
-- config.automatically_reload_config = true
-- config.exit_behavior = 'CloseOnCleanExit'
-- config.exit_behavior_messaging = 'Verbose'
-- config.status_update_interval = 50000
-- config.hyperlink_rules = {
--     {regex = '\\', format = '1', highlight = 1},
--     {regex = '\\{(\\w+://\\S+)\\}', format = '1', highlight = 1},
--     {regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+', format = '0'}
-- }

return config
