local wezterm = require 'wezterm'

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

config.font_size = 14.0

print("Test")

return config

