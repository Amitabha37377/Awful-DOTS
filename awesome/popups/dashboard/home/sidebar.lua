--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Color modules
local color = require("popups.color")

local create_button = function(text, text_color, bg_color, bg_hover, bg_press, signal)
	local textbox = wibox.widget {
		markup = '<span color="' ..
				text_color .. '" font="Ubuntu Nerd Font Bold 18">' .. text .. '</span>',
		font = "Ubuntu Nerd Font Bold 14",
		widget = wibox.widget.textbox,
		fg = color.white
	}

	local button = wibox.widget {
		{
			textbox,
			widget = wibox.container.margin,
			top = dpi(9),
			bottom = dpi(9),
			right = dpi(8),
			left = dpi(11),
		},
		widget = wibox.container.background,
		bg = bg_color,
		forced_width = dpi(45),
		-- forced_height = dpi(45),
		shape = function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, 5)
		end,
	}

	button:connect_signal("button::press", function()
		button.bg = bg_press
	end)

	button:connect_signal("button::release", function()
		button.bg = color.background_lighter
		awesome.emit_signal(signal)
	end)

	return button
end

local home = create_button('', color.grey, color.background_lighter, color.background_lighter,
	color.background_lighter, "dashboard::home")
local sys_monitor = create_button('', color.grey, color.bg_blackest, color.background_dark, color.background_lighter,
	"dashboard::sys_monitor")
local todo = create_button('', color.grey, color.bg_blackest, color.background_dark, color.background_lighter,
	"dashboard::todo")
local settings = create_button('', color.grey, color.bg_blackest, color.background_dark, color.background_lighter,
	"dashboard::settings")


local change_button_color = function(button, other1, other2, other3)
	button:connect_signal("button::release", function()
		button.bg = color.background_lighter
		other1.bg = color.bg_blackest
		other2.bg = color.bg_blackest
		other3.bg = color.bg_blackest
	end)
end

change_button_color(home, sys_monitor, todo, settings)
change_button_color(todo, home, sys_monitor, settings)
change_button_color(sys_monitor, home, todo, settings)
change_button_color(settings, home, todo, sys_monitor)

local main = wibox.widget {
	{
		{
			{
				home,
				widget = wibox.container.margin,
				top = dpi(4),
				bottom = dpi(4)
			},
			{
				todo,
				widget = wibox.container.margin,
				top = dpi(4),
				bottom = dpi(4)
			},
			{
				sys_monitor,
				widget = wibox.container.margin,
				top = dpi(4),
				bottom = dpi(4)
			},
			{
				settings,
				widget = wibox.container.margin,
				top = dpi(4),
				bottom = dpi(4)
			},
			-- todo,
			-- sys_monitor,
			-- settings,
			layout = wibox.layout.fixed.vertical
		},
		widget = wibox.container.margin,
		left = dpi(7),
		right = dpi(7),
		top = dpi(10)
	},
	widget = wibox.container.background,
	bg = color.bg_blackest,
	forced_height = dpi(950),
}



return main
