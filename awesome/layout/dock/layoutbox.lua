--Standard MOdules
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require('helpers')
--Colors
local color = require("themes.colors")

local mylayoutbox = awful.widget.layoutbox()
mylayoutbox:buttons(gears.table.join(
	awful.button({}, 1, function()
		awful.layout.inc(1)
	end),
	awful.button({}, 3, function()
		awful.layout.inc(-1)
	end),
	awful.button({}, 4, function()
		awful.layout.inc(1)
	end),
	awful.button({}, 5, function()
		awful.layout.inc(-1)
	end)
))

-- mylayoutbox.forced_height =

local layoutbox = wibox.widget { {
	mylayoutbox,
	bg = color.bg_dark,
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
},
	widget = wibox.container.place,

	forced_width = dpi(40),
	forced_height = dpi(40)
}

local btn = helpers.margin(layoutbox, 7, 10, 9, 9)
return btn
