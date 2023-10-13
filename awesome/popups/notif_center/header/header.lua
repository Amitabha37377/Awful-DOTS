--Standard Modules
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi


--Custom Modules
local color = require("popups.color")

--Username
local header_text = wibox.widget {
	{
		markup = '<span color="' ..
				color.blueish_white .. '" font="Ubuntu Nerd Font Bold 14">' .. 'Notification Center' .. '</span>',
		font = "Ubuntu Nerd Font Bold 14",
		widget = wibox.widget.textbox,
		fg = color.white
	},
	widget = wibox.container.margin,
	top = dpi(5),
	bottom = dpi(5),
	right = dpi(5),
	left = dpi(10),
}

--Main Widget
local header = wibox.widget {
	{
		{
			header_text,
			layout = wibox.layout.fixed.horizontal,
		},
		widget = wibox.container.margin,
		top = dpi(3),
		bottom = dpi(3),
		right = dpi(3),
		left = dpi(3),
	},
	widget = wibox.container.background,
	bg = color.background_lighter,
	forced_width = dpi(300),
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 10)
	end,

}

return header
