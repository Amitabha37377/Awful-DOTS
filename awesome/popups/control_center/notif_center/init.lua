local wibox = require('wibox')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi
local helpers = require('helpers')
local color = require("themes.colors")

local notifs = require('popups.control_center.notif_center.notifs')

local header_text = helpers.textbox(color.lightblue, "Ubuntu nerd font bold 18", "Notifications")
header_text.valign = 'center'
header_text.forced_height = dpi(40)

local btn = wibox.widget {
	helpers.margin(
		wibox.widget {
			helpers.textbox(color.blue, "Ubuntu nerd font 18", '󰎟'),
			widget = wibox.container.place
		},
		8, 8, 8, 8
	),
	widget = wibox.container.background,
	bg = color.bg_dark,
	border_width = 3,
	border_color = color.bg_dim,
	shape = helpers.rrect(40, 40)

}

btn.forced_height = dpi(40)
btn.forced_width = dpi(40)

helpers.add_hover_effect(btn, color.bg_dark .. 'bd', color.bg_normal, color.bg_dark)

local button = wibox.widget {
	btn,
	widget = wibox.container.place,
	valign = 'center'
}

button:connect_signal("button::release", function()
	awesome.emit_signal("notifs::clear")
end)

local header = wibox.widget {
	{
		header_text,
		nil,
		button,
		layout = wibox.layout.align.horizontal
	},
	widget = wibox.container.margin,
	margins = dpi(20),
}


local notif_center = wibox.widget {
	{
		-- sep,
		{
			header,
			helpers.margin(notifs, 0, 10, 0, 10),
			layout = wibox.layout.fixed.vertical
		},
		widget = wibox.container.background,
		bg = color.bg_dark,
		shape = helpers.rrect(15),
	},
	widget        = wibox.container.margin,
	forced_width  = dpi(450),
	forced_height = dpi(560),
	top           = dpi(0),
	left          = dpi(10),
	right         = dpi(10)
}

return notif_center
