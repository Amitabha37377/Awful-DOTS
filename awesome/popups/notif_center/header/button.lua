local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local color = require("popups.color")
local icon_path = os.getenv("HOME") .. "/.config/awesome/popups/notif_center/assets/"
--Powerbutton
local clear = wibox.widget { {
	{
		image = icon_path .. "clear_all.png",
		widget = wibox.widget.imagebox,
		resize = true,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 20)
		end,

	},
	widget = wibox.container.margin,
	top = dpi(8),
	bottom = dpi(8),
	right = dpi(13),
	left = dpi(9),
	forced_height = dpi(40)
},
	widget = wibox.container.background,
	bg = color.background_lighter,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 4)
	end,

}

--Hover highlight effects
clear:connect_signal("mouse::enter", function()
	clear.bg = "#343b58"
end)

clear:connect_signal("mouse::leave", function()
	clear.bg = color.background_lighter
end)

clear:connect_signal("button::press", function()
	clear.bg = color.background_morelight
end)

clear:connect_signal("button::release", function()
	clear.bg = "#343b58"
end)

clear:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		awesome.emit_signal("notif::clearall")
	end
end)

--notification button
local close = wibox.widget { {
	{
		image = icon_path .. "close.png",
		widget = wibox.widget.imagebox,
		resize = true,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 20)
		end,

	},
	widget = wibox.container.margin,
	top = dpi(7),
	bottom = dpi(7),
	right = dpi(6),
	left = dpi(11),
	forced_height = dpi(40)
},
	widget = wibox.container.background,
	bg = color.background_lighter,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 4)
	end,

}

--Hover highlight effects
close:connect_signal("mouse::enter", function()
	close.bg = "#343b58"
end)

close:connect_signal("mouse::leave", function()
	close.bg = color.background_lighter
end)

close:connect_signal("button::press", function()
	close.bg = color.background_morelight
end)

close:connect_signal("button::release", function()
	close.bg = "#343b58"
end)

close:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		awesome.emit_signal("widget::notif_close")
	end
end)

--Separator
local vertical_separator = wibox.widget {
	orientation = 'vertical',
	forced_height = dpi(1.5),
	forced_width = dpi(1.5),
	span_ratio = 0.55,
	widget = wibox.widget.separator,
	color = "#a9b1d6",
	border_color = "#a9b1d6",
	opacity = 0.55
}

--Main Widget
local buttons = wibox.widget {
	{
		{
			clear,
			vertical_separator,
			close,
			layout = wibox.layout.fixed.horizontal,
		},
		widget = wibox.container.margin,
		top = dpi(6),
		bottom = dpi(6),
		right = dpi(6),
		left = dpi(6),
	},
	widget = wibox.container.background,
	bg = color.background_lighter,
	forced_width = dpi(104),
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 10)
	end,
}

return buttons
