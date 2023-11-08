local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
local gears = require('gears')

local dpi = beautiful.xresources.apply_dpi
local helpers = require('helpers')
local color = require("themes.colors")

local slider = wibox.widget({
	widget = wibox.widget.slider,
	bar_shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 25)
	end,

	bar_height = dpi(8),
	bar_color = color.mid_dark,
	bar_active_color = color.blue,
	handle_shape = gears.shape.circle,
	handle_color = color.lightblue,
	handle_width = dpi(25),
	handle_border_width = 3,
	handle_border_color = color.bg_dark,
	minimum = 0,
	maximum = 100,
	value = 69,
})

local icon = helpers.margin(
	helpers.textbox(color.orange, "Ubuntu nerd font bold 30", '󰃠'),
	0, 15, 5, 5
)

local brightness_slider = helpers.margin(
	wibox.widget {
		{
			icon,
			slider,
			layout = wibox.layout.fixed.horizontal
		},
		widget = wibox.container.margin,
		-- margins = dpi(10),
		forced_height = dpi(60),
		forced_width = dpi(400),
	},
	30, 30, 0, 10)

return brightness_slider
