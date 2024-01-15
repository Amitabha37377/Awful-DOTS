--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Custom Modules
local color = require("popups.color")
local user = require("popups.user_profile")

-----------------------
--Header text----------
-----------------------

local textbox = wibox.widget {
	markup = '<span color="' ..
			color.green .. '" font="Ubuntu Nerd Font bold 16">' .. "Touch Grass 󱔐" .. '</span>',
	font = "Ubuntu Nerd Font 14",
	widget = wibox.widget.textbox,
	fg = color.white
	, align = 'center'
}

---------------------
--Main widget--------
---------------------

local button = wibox.widget {
	{
		textbox,
		widget = wibox.container.margin,
		top = dpi(7),
		bottom = dpi(5),
		right = dpi(5),
		left = dpi(8),
	},
	widget = wibox.container.background,
	bg = color.background_lighter,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 7)
	end,
}

local exit_button = wibox.widget {
	button,
	widget = wibox.container.margin,
	bottom = dpi(14),
	left = dpi(12),
	right = dpi(12),
	forced_height = dpi(69),


}

button:connect_signal("mouse::enter", function()
	button.bg = color.background_lighter2
end)

button:connect_signal("mouse::leave", function()
	button.bg = color.background_lighter
end)

button:connect_signal("button::press", function()
	button.bg = color.background_morelight
end)

button:connect_signal("button::release", function()
	button.bg = color.background_lighter2
end)


exit_button:connect_signal("button::release", function(_, _, _, button)
	awesome.emit_signal("widget::powermenu2")
end)


return exit_button
