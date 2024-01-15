local awful         = require 'awful'
local wibox         = require 'wibox'
local beautiful     = require 'beautiful'
local dpi           = beautiful.xresources.apply_dpi

local color         = require 'themes.colors'
local helpers       = require 'helpers'

local systray_text  = helpers.textbox(color.fg_normal, "Ubuntu nerd font bold 18", '')
systray_text.valign = 'center'
systray_text.halign = 'center'

local sys           = wibox.widget {
	widget     = wibox.widget.systray,
	horizontal = false
}

local systray       = wibox.widget { {
	sys,
	widget       = wibox.container.margin,
	left         = dpi(5),
	right        = dpi(5),
	top          = dpi(5),
	bottom       = dpi(0),
	forced_width = dpi(30)
},
	widget = wibox.container.constraint,
	strategy = 'max',
	height = dpi(100),
}


local sys_bg = wibox.widget {
	{
		systray,
		helpers.margin(systray_text, 5, 5, 5, 5),
		layout = wibox.layout.fixed.vertical
	},
	widget = wibox.container.background,
	bg = color.bg_dark,
	shape = helpers.rrect(4)
}

systray_text:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		systray.visible = not systray.visible
		if systray.visible then
			systray_text.markup = helpers.mtext(color.fg_normal, "Ubuntu nerd font bold 18", '')
		else
			systray_text.markup = helpers.mtext(color.fg_normal, "Ubuntu nerd font bold 18", '')
		end
	end
end)



return helpers.margin(sys_bg, 5, 5, 5, 5)
