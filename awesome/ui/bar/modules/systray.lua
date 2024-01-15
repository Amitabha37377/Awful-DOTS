local wibox = require 'wibox'
local beautiful = require 'beautiful'
local dpi = beautiful.xresources.apply_dpi

local helpers = require 'helpers'
local color = require 'themes.colors'

local toggle_arrow = helpers.textbox(color.mid_light, "Ubuntu nerd font bold 20", '')

local tray_toggle = helpers.margin(
	toggle_arrow, 8, 3, 8, 8
)

local systray = wibox.widget {
	wibox.widget.systray(),
	widget  = wibox.container.margin,
	left    = dpi(5),
	right   = dpi(5),
	top     = dpi(5),
	bottom  = dpi(5),
	visible = true,
}

local togglableSystray = wibox.widget {
	{
		{
			systray,
			tray_toggle,
			layout = wibox.layout.fixed.horizontal,
		},
		widget = wibox.container.background,
		bg     = color.bg_dark
	},
	left   = dpi(3),
	right  = dpi(0),
	top    = dpi(3),
	bottom = dpi(3),
	widget = wibox.container.margin
}

tray_toggle:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		systray.visible = not systray.visible
		if systray.visible then
			toggle_arrow.markup = helpers.mtext(color.mid_light, "Ubuntu nerd font bold 20", '')
		else
			toggle_arrow.markup = helpers.mtext(color.mid_light, "Ubuntu nerd font bold 20", '')
		end
	end
end)


return togglableSystray
