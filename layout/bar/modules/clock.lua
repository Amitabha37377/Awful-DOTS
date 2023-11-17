local awful        = require 'awful'
local wibox        = require 'wibox'
local beautiful    = require 'beautiful'
local dpi          = beautiful.xresources.apply_dpi

local color        = require 'themes.colors'
local helpers      = require 'helpers'

local textclock    = wibox.widget {
	widget = wibox.widget.textclock,
	format = '<span color="' .. color.fg_normal .. '" font="Ubuntu Nerd Font Bold 16">%H\n%M</span>',
	refresh = 20,
	valign = 'center'
}

local clock_bg     = wibox.widget {
	helpers.margin(textclock, 8, 8, 8, 8),
	widget = wibox.container.background,
	bg = color.bg_dim,
	shape = helpers.rrect(4)
}

local final        = helpers.margin(clock_bg, 5, 5, 5, 5)
final.forced_width = dpi(50)

return final
