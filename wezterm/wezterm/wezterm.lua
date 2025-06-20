local util = require("modules.util")

-- Pull in the wezterm API
local wezterm = require("wezterm")

local configHome = os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config"

local imgdir = util.joinPaths(configHome, "img", "wallpapers")

require("modules.background"):set_files(imgdir):random()

-- This will hold the configuration.
local config = wezterm.config_builder()

config.background = {
	{
		source = {
			File = wezterm.GLOBAL.background,
		},
		horizontal_align = "Center",
		opacity = 1,
		hsb = {
			-- Darken the background image by reducing it to 1/3rd
			brightness = 0.3,

			-- You can adjust the hue by scaling its value.
			-- a multiplier of 1.0 leaves the value unchanged.
			hue = 1.0,

			-- You can adjust the saturation also.
			saturation = 1.0,
		},
	},
}

-- This is where you actually apply your config choices
config.hide_tab_bar_if_only_one_tab = true

-- For example, changing the color scheme:
config.color_scheme = "Argonaut"

config.font = wezterm.font("Fixedsys Core")

-- and finally, return the configuration to wezterm
return config
