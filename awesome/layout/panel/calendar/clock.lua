local awful     = require 'awful'
local wibox     = require('wibox')
local beautiful = require('beautiful')

local dpi       = beautiful.xresources.apply_dpi
local helpers   = require('helpers')
local color     = require("themes.colors")


local hr = wibox.widget {
	widget = wibox.widget.textclock,
	format = '<span color="' .. color.lightblue .. '" font="Ubuntu Nerd Font Bold 65"> %H </span>',
	refresh = 20,
}

local min = wibox.widget {
	widget = wibox.widget.textclock,
	format = '<span color="' .. color.lightblue .. '" font="Ubuntu Nerd Font Bold 65"> %M </span>',
	refresh = 20,
}

local date = wibox.widget {
	widget = wibox.widget.textclock,
	format = '<span color="' .. color.fg_normal .. '" font="Ubuntu Nerd Font Bold 20">%A,  %B  %d</span>',
	refresh = 20,
}



local dot = function(clr)
	return helpers.textbox(clr, "Ubuntu nerd font 10", '')
end

local sep = wibox.widget { {
	helpers.margin(dot(color.orange), 0, 0, 3, 1),
	helpers.margin(dot(color.green), 0, 0, 3, 1),
	helpers.margin(dot(color.purple), 0, 0, 3, 1),
	layout = wibox.layout.fixed.vertical,
},
	widget = wibox.container.margin,
	margins = dpi(3) }

local clock = wibox.widget {
	{
		{
			{
				hr,
				{ sep, widget = wibox.container.place },
				min,
				layout = wibox.layout.fixed.horizontal
			},
			date,
			layout = wibox.layout.fixed.vertical
		},
		widget = wibox.container.place
	},
	widget = wibox.container.margin,
	margins = dpi(20) }

return clock
