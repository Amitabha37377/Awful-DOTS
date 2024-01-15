local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi
local helpers = require('helpers')
local color = require("themes.colors")

local apps = require('ui.bar.center.apps')
local layoutbox = require('ui.bar.center.layoutbox')
local tasklist = require('ui.bar.center.tasklist')

local vertical_separator = helpers.margin(wibox.widget {
		orientation = 'vertical',
		forced_height = dpi(1.5),
		forced_width = dpi(1.5),
		span_ratio = 0.55,
		widget = wibox.widget.separator,
		color = "#a9b1d6",
		border_color = "#a9b1d6",
		opacity = 0.55
	},
	5, 9, 0, 0)


local apps = wibox.widget {
	{
		{
			apps.firefox,
			apps.term,
			apps.files,
			apps.telegram,
			apps.discord,
			apps.gimp,
			vertical_separator,
			tasklist,
			layoutbox,
			layout = wibox.layout.fixed.horizontal,
		},
		widget = wibox.container.place
	},
	widget = wibox.container.margin,
	margins = dpi(5)
}

return apps
