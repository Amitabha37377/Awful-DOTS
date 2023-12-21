local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local dpi = beautiful.xresources.apply_dpi

local helpers = require('helpers')
local color = require('themes.colors')
local user = require("user")

local txt = {
	"Goodbye " .. user.name,
	"Touch Grass?"
}

local header_txt = helpers.textbox(color.green, "Ubuntu nerd font bold 30", txt[1])
header_txt.valign = 'center'
header_txt.halign = 'center'

local header = wibox.widget {
	helpers.margin(header_txt, 10, 10, 25, 20),
	{
		orientation = 'horizontal',
		forced_height = dpi(1.5),
		forced_width = dpi(1.5),
		span_ratio = 0.75,
		widget = wibox.widget.separator,
		color = color.fg_normal,
		border_color = color.fg_normal,
		opacity = 0.6
	},

	layout = wibox.layout.fixed.vertical
}

return header
