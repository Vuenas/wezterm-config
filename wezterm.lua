local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.unix_domains = {
  { 
    name = "unix",
  }
}

config.default_gui_startup_args = { 'connect', 'unix' }


config.color_scheme = 'Catppuccin Macchiato'

config.enable_tab_bar = true
config.use_fancy_tab_bar = true

config.window_decorations = "RESIZE"

config.front_end = "WebGpu"

config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.7,
}

config.window_frame = {
  inactive_titlebar_bg = '#23273C',
  active_titlebar_bg = '#23273C',
  inactive_titlebar_fg = '#cccccc',
  active_titlebar_fg = '#ffffff',
  inactive_titlebar_border_bottom = '#23273C',
  active_titlebar_border_bottom = '#23273C',
  button_fg = '#cccccc',
  button_bg = '#2b2042',
  button_hover_fg = '#ffffff',
  button_hover_bg = '#3b3052',
  border_right_width = "1cell"
}

config.keys = {
  -- split panes --
  {
    key = "d",
    mods = "CMD",
    action = wezterm.action.SplitHorizontal
  },
  {
    key = "d",
    mods = "SHIFT|CMD",
    action = wezterm.action.SplitVertical
  },
  -- close pane --
  {
    key = "w",
    mods = "CMD",
    action = wezterm.action{CloseCurrentPane={confirm=true}}
  },
  -- toggle full screen --
  {
    key = "Enter",
    mods = "CMD|SHIFT",
    action = wezterm.action.TogglePaneZoomState
  },
  -- navigate through panes --
  {
    key = "LeftArrow",
    mods = "CMD",
    action = wezterm.action.ActivatePaneDirection("Left")
  },
  {
    key = "RightArrow",
    mods = "CMD",
    action = wezterm.action.ActivatePaneDirection("Right")
  },
  {
    key = "UpArrow",
    mods = "CMD",
    action = wezterm.action.ActivatePaneDirection("Up")
  },
  {
    key = "DownArrow",
    mods = "CMD",
    action = wezterm.action.ActivatePaneDirection("Down")
  },
  -- clear terminal --
  {
    key = "k",
    mods = "CMD",
    action = wezterm.action.ClearScrollback "ScrollbackAndViewport"
  },
  -- Word navigation --
  {
    key = "LeftArrow",
    mods = "OPT",
    action = wezterm.action{SendString="\x1bb"}
  },
  {
    key = "RightArrow",
    mods = "OPT",
    action = wezterm.action{SendString="\x1bf"}
  },
  -- Start / end navigation --
  {
    key = "UpArrow",
    mods = "OPT",
    action = wezterm.action{SendString="\x01"}
  },
  {
    key = "DownArrow",
    mods = "OPT",
    action = wezterm.action{SendString="\x05"}
  },

  -- Tab navigation --
  {
    key = "LeftArrow",
    mods = "CMD|OPT",
    action = wezterm.action.ActivateTabRelative(-1)
  },
  {
    key = "RightArrow",
    mods = "CMD|OPT",
    action = wezterm.action.ActivateTabRelative(1)
  }
}

-- time in status bar --
wezterm.on("update-right-status", function(window, pane)
  local date = wezterm.strftime "%a %b %d %H:%M:%S"

  window:set_right_status(wezterm.format {
    { Background = { Color = "#23273C" } },
    { Text = date }
  })
end)

-- tab styling --

function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wezterm.on(
  "format-tab-title",
  function(tab, tabs, panes, config, hover, max_width)
    local background = "#1b1032"
    local title = tab_title(tab)
    title = wezterm.truncate_right(title, max_width)

    if tab.is_active then
      background = "#23273C"
    end

    return {
      { Background = { Color = background } },
    --  { Foreground = { Color = "#245442" } }, --
      { Text = title },
    }
  end
)

return config
