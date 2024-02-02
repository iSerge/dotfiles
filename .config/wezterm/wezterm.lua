local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.enable_wayland = true
config.color_scheme = 'Solarized Light (Gogh)'

config.font = wezterm.font_with_fallback {
  'PragmataProMonoLiga Nerd Font',
  'PragmatePro Mono Liga',
}

config.font_size = 15.0

config.initial_rows = 40
config.initial_cols = 120

-- Activate tabs 1 to 8 with C+A+n or Fn keys
config.keys = {}
for i = 1, 8 do
  -- CTRL+ALT + number to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'CTRL|ALT',
    action = act.ActivateTab(i - 1),
  })
  -- F1 through F8 to activate that tab
  table.insert(config.keys, {
    key = 'F' .. tostring(i),
    action = act.ActivateTab(i - 1),
  })
end

-- Move between tabs with A+{ A+} keys
config.keys = {
  { key = '{', mods = 'ALT', action = act.ActivateTabRelative(-1) },
  { key = '}', mods = 'ALT', action = act.ActivateTabRelative(1) },
}

-- Close current tab
config.keys = {
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
}

-- Create new tab
config.keys = {
  -- Create a new tab in the same domain as the current pane.
  -- This is usually what you want.
  {
    key = 't',
    mods = 'SHIFT|ALT',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
}

return config

