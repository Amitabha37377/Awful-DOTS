local awful = require 'awful'
local beautiful = require 'beautiful'
local wibox = require 'wibox'
local dpi = beautiful.xresources.apply_dpi

local helpers = require 'helpers'
local color = require 'themes.colors'

local header = wibox.widget {
	{
		helpers.margin(
			helpers.textbox(color.lightblue, "Ubuntu nerd font bold 16", "Timer and Todo"),
			20, 10, 10, 10
		),
		widget = wibox.container.background,
		bg = color.bg_normal,
		shape = helpers.rrect(15)
	},
	widget = wibox.container.margin,
	margins = dpi(10)
}

return header
