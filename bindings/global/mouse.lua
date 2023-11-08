local awful = require 'awful'
local menu = require 'ui.menu'
-- local widgets = require 'widgets'

awful.mouse.append_global_mousebindings {
	awful.button {
		modifiers = {},
		button    = 3,
		on_press  = function() menu:toggle() end
	},
	awful.button {
		modifiers = {},
		button    = 4,
		on_press  = awful.tag.viewprev
	},
	awful.button {
		modifiers = {},
		button    = 5,
		on_press  = awful.tag.viewnext
	},
}
