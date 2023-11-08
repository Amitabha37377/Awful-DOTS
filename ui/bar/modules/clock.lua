local wibox        = require 'wibox'
local beautiful    = require 'beautiful'
local dpi          = beautiful.xresources.apply_dpi

local helpers      = require 'helpers'
local color        = require 'themes.colors'

local battery      = require 'ui.bar.modules.battery'
-- local textclock   = wibox.widget.textclock(
-- '<span color="' .. color.lightblue .. '" font="Ubuntu Nerd Font Bold 16">  %H:%M </span>', 10)

local textclock    = wibox.widget {
	widget = wibox.widget.textclock,
	format = '<span color="' .. color.lightblue .. '" font="Ubuntu Nerd Font Bold 16">  %H:%M </span>',
	refresh = 20,
	valign = 'center'
}

local clock        = wibox.widget
		{
			textclock,
			widget = wibox.container.margin,
			margins = dpi(0)
		}

local clock_final  = helpers.margin(clock, 3, 6, 6, 6)

local time_showing = true

clock_final:connect_signal("button::release", function()
	time_showing = not time_showing
	if not time_showing then
		textclock.format = '<span color="' .. color.lightblue .. '" font="Ubuntu Nerd Font Bold 16"> %A, %b %d </span>'
	else
		textclock.format = '<span color="' .. color.lightblue .. '" font="Ubuntu Nerd Font Bold 16">  %H:%M </span>'
	end
end)

local vertical_separator = wibox.widget {
	orientation = 'vertical',
	forced_height = dpi(1.5),
	forced_width = dpi(1.5),
	span_ratio = 0.55,
	widget = wibox.widget.separator,
	color = "#a9b1d6",
	border_color = "#a9b1d6",
	opacity = 0.55
}

local main = wibox.widget { {
	{
		helpers.margin(battery({
				show_current_level = true,
				arc_thickness = 3,
				size = 28,
				font = "Ubuntu nerd font bold 10",
				margins = 55,
				timeout = 10,
				main_color = color.lightblue
			}),
			11, 3, 0, 0),

		helpers.margin(vertical_separator, 9, 0, 6, 6),
		clock_final,
		layout = wibox.layout.fixed.horizontal
	},
	widget = wibox.container.margin,
	margins = dpi(0),
},
	widget = wibox.container.background,
	bg = color.bg_normal,
	shape = helpers.rrect(4) }

helpers.add_hover_effect(main, color.bg_light, color.mid_dark, color.bg_normal)

return helpers.margin(main, 3, 6, 6, 6)
