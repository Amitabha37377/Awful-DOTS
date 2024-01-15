local wezterm = require "wezterm"

local tab_bar_style = {
	color = {
		background = "#1a1b26",
		inactive_tab_edge = '#8389a8',

		active_tab = {
			bg_color = "#343b58",
			intensity = "Bold",
			fg_color = "#e0af68"
		},

		inactive_tab = {
			bg_color = "#24283b",
			fg_color = "#8389a8",
		},

		inactive_tab_hover = {
			bg_color = "#24283b",
			fg_color = "#89b4fa"
		},

		new_tab = {
			bg_color = "#1a1b26",
			fg_color = "#bb9af7",
			intensity = "Bold"
		},

		new_tab_hover = {
			bg_color = "#222233",
			fg_color = "#73daca"
		},
		inactive_tab_edge = '#24283b',
	},

	window_frame = {
		font = wezterm.font {
			family = "CodeNewRoman Nerd Font",
			weight = "Bold"
		},
		font_size = 12.0,
		active_titlebar_bg = "#1a1b26",

	}

}

return tab_bar_style
