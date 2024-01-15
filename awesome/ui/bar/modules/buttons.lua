local wibox = require 'wibox'
local beautiful = require 'beautiful'
local dpi = beautiful.xresources.apply_dpi

local helpers = require 'helpers'
local color = require 'themes.colors'

local create_button = function(icon, fg)
	local button = helpers.margin(helpers.textbox(fg, "Ubuntu nerd font bold 20", icon), 6, 6, 5, 5)
	return button
end

local control_center = create_button('', color.green)
local notifi_center = create_button('󰂚', color.orange)
local screenshot = create_button('󰄄', color.cyan)

control_center:connect_signal("button::release", function(_, _, _, button)
	if button == 1 then
		awesome.emit_signal('control::toggle')
	end
end)




local right = wibox.widget {
	{
		{
			{
				screenshot,
				control_center,
				notifi_center,
				layout = wibox.layout.fixed.horizontal
			},
			widget = wibox.container.margin,
			left = dpi(6),
			right = dpi(5)
		},
		widget = wibox.container.background,
		bg = color.bg_normal,
		shape = helpers.rrect(4)
	},
	widget = wibox.container.margin,
	top = dpi(6),
	bottom = dpi(6),
	right = dpi(6),
	left = dpi(9)
}

return right
