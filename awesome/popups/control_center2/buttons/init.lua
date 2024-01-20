local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi
local helpers = require('helpers')
local color = require("themes.colors")

local buttons = require("popups.control_center.buttons.buttons")

local main = wibox.widget {
	{
		{
			{
				buttons.wifi,
				buttons.bluetooth,
				buttons.dnd,
				buttons.dark_mode,
				layout = wibox.layout.fixed.horizontal
			},
			{
				buttons.Silent,
				buttons.night_mode,
				buttons.settings,
				buttons.caffeinr,
				layout = wibox.layout.fixed.horizontal
			},

			layout = wibox.layout.fixed.vertical
		},
		widget = wibox.container.place
	},
	widget = wibox.container.margin,
	margins = dpi(10)
}

return main
