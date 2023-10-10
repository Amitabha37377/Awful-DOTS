local wezterm = require("wezterm")


local config = {
	font = wezterm.font {
		family = 'CodeNewRoman Nerd Font',
		weight = 'Regular',
		stretch = "Expanded",
		harfbuzz_features = { 'calt=0', 'clig=0', 'liga=1' },
	},
	font_size = 16.0,

	colors = require("color"),
	keys = require("keybindings"),
	window_frame = require("tab_bar").window_frame,

	tab_bar_at_bottom = true,
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = false,

	inactive_pane_hsb = {
		saturation = 1.0,
		brightness = 1.0,
	},

	window_padding = {
		left = 8,
		right = 8,
		top = 8,
		bottom = 8,
	}
}

return config
