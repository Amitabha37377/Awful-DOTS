local awful = require 'awful'
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local dpi = beautiful.xresources.apply_dpi

local color = require 'themes.colors'
local helpers = require 'helpers'

local create_button = function(icon, fg)
	local text = helpers.textbox(fg, "Ubuntu nerd font bold 20", icon)
	text.valign = 'center'
	text.halign = 'center'

	local button = helpers.margin(text, 5, 5, 5, 5)
	return button
end

local control_center = create_button('', color.green)
local mplayer = create_button('󰋋', color.orange)
local screenshot = create_button('󰄄', color.cyan)

local bottom = wibox.widget {
	{
		{
			mplayer,
			control_center,
			screenshot,
			layout = wibox.layout.fixed.vertical
		},
		widget = wibox.container.background,
		bg = color.bg_dim
	},
	widget = wibox.container.margin,
	margins = dpi(5)
}

mplayer:connect_signal("button::release", function()
	awesome.emit_signal("mplayer::toggle")
end)

return bottom
