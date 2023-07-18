local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.enable_wayland = true
config.color_scheme = 'Solarized Light (Gogh)'

print("Test")

return config

