local awful         = require "awful"
local wibox         = require "wibox"
local beautiful     = require('beautiful')

local dpi           = beautiful.xresources.apply_dpi
local helpers       = require('helpers')
local color         = require("themes.colors")

local create_slider = function(name, max, current, color1, color2)
	local progress = {
		id               = "pro",
		max_value        = max,
		value            = current,
		forced_height    = 20,
		forced_width     = 250,
		bar_shape        = helpers.rrect(5),
		shape            = helpers.rrect(5),
		color            = color1,
		background_color = color.bg_light,
		paddings         = 1,
		border_width     = 1,
		widget           = wibox.widget.progressbar,
	}

	local label =
			helpers.margin(helpers.textbox(color2, "Ubuntu nerd font bold 16", name), 15, 6, 0, 0)

	label.forced_width = dpi(80)

	local final = wibox.widget {
		label,
		helpers.margin(progress, 6, 15, 0, 0),
		layout = wibox.layout.align.horizontal
	}

	return helpers.margin(final, 3, 3, 15, 15)
end

local sys           = wibox.widget {
	{
		{
			create_slider('CPU', 100, 6, color.orange, color.red),
			create_slider('RAM', 100, 25, color.green, color.red),
			create_slider('DISK', 100, 69, color.purple, color.red),
			layout = wibox.layout.fixed.vertical
		},
		widget = wibox.container.margin,
		margins = dpi(10)
	},
	widget = wibox.container.background,
	bg = color.bg_normal,
	shape = helpers.rrect(15) }

return helpers.margin(sys, 10, 10, 10, 10)
