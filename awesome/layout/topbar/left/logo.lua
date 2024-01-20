local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helpers = require 'helpers'
local color = require 'themes.colors'

local button = wibox.widget {
	{
		{
			widget = wibox.widget.imagebox,
			image = os.getenv("HOME") .. "/.config/awesome/assets/others/awesome-config-logo.jpg",
			resize = true,
			opacity = 1,
		},
		left = dpi(18),
		top = dpi(7),
		bottom = dpi(7),
		right = dpi(15),
		widget = wibox.container.margin
	},
	widget = wibox.container.background,
	bg = color.bg_dim,
}

return button
