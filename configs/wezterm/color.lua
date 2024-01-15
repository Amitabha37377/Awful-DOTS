local tab_bar_settings = require "tab_bar"

local colors = {
	foreground = 'silver',
	background = "#0e0f18",

	cursor_bg = '#fac814',
	cursor_fg = 'black',
	cursor_border = '#52ad70',

	selection_fg = 'black',
	selection_bg = '#fffacd',

	scrollbar_thumb = '#222222',

	split = '#444444',

	ansi = {
		'#321200',
		'#b1270e',
		'#44a900',
		'#a9810b',
		'#5300eb',
		'#96363c',
		'#b2591d',
		'#ff9800',
	},
	brights = {
		'#423635',
		'#ed5c24',
		'#55f237',
		'#f1b731',
		'#004dcf',
		'#e04b5a',
		'#f07c14',
		'#ffc800',
	},

	indexed = { [136] = '#af8700' },

	compose_cursor = 'orange',

	copy_mode_active_highlight_bg = { Color = '#000000' },
	copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
	copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
	copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },

	quick_select_label_bg = { Color = 'peru' },
	quick_select_label_fg = { Color = '#ffffff' },
	quick_select_match_bg = { AnsiColor = 'Navy' },
	quick_select_match_fg = { Color = '#ffffff' },

	tab_bar = tab_bar_settings.color,

}

return colors
