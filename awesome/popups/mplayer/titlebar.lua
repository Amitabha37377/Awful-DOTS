local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local dpi = beautiful.xresources.apply_dpi

local helpers = require('helpers')
local color = require('themes.colors')

local close = helpers.textbox(color.red, "Ubuntu nerd font bold 16", "  ")
local pin_top = helpers.textbox(color.green, "Ubuntu nerd font bold 16", "  ")
local pin_bottom = helpers.textbox(color.orange, "Ubuntu nerd font bold 16", "  ")

local add_signal = function(button, signal)
	button:connect_signal("button::release", function()
		awesome.emit_signal(signal)
	end)
end

add_signal(close, "mplayer::close")
add_signal(pin_top, "mplayer::pin_top")
add_signal(pin_bottom, "mplayer::pin_bottom")

local titlebar = wibox.widget {
	{
		{
			helpers.textbox(color.lightblue, "Ubuntu nerd font bold 13", "Music Player"),
			nil,
			{ pin_top, pin_bottom, close, layout = wibox.layout.fixed.horizontal },
			layout = wibox.layout.align.horizontal
		},
		widget = wibox.container.margin,
		margins = dpi(15)
	},
	widget = wibox.container.background,
	bg = color.bg_dark,
	border_width = dpi(3),
	border_color = color.bg_dark
}

return titlebar
