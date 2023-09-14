--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Custom Modules
local user = require("popups.user_profile")
local color = require("popups.color")

--Separator
local Separator = wibox.widget.textbox("    ")
Separator.forced_height = dpi(4)

--Conatiners
local container = require("popups.control_center.buttons.container")

--Function for creating button
local create_button = function(container_widget, text, on_status, bg_click, command1, command2)
	local on_off = function()
		if on_status == true then
			return "on"
		else
			return "off"
		end
	end

	local text_status = wibox.widget {
		markup = '<span color="' .. color.white .. '" font="Ubuntu Nerd Font 11">' .. on_off() .. '</span>',
		font = "Ubuntu Nerd Font Bold 14",
		widget = wibox.widget.textbox,
		fg = color.white
	}

	local text_button = wibox.widget {
		{
			{
				markup = '<span color="' ..
					color.blueish_white .. '" font="Ubuntu Nerd Font bold 11">' .. text .. '</span>',
				font = "Ubuntu Nerd Font Bold 14",
				widget = wibox.widget.textbox,
				fg = color.white
			},
			Separator,
			text_status,
			layout = wibox.layout.fixed.vertical,
			id = "wifi",
		},
		widget = wibox.container.margin,
		top = dpi(8),
		bottom = dpi(8),
		right = dpi(8),
		left = dpi(8),
		forced_height = dpi(56),
	}

	local button_container = wibox.widget {
		container_widget,
		widget = wibox.container.margin,
		top = 3,
		bottom = 3,
		right = 10,
		left = 7,
		forced_height = dpi(56)
	}

	--Functionality
	button_container:connect_signal("button::press", function()
		on_status = not on_status
		if on_status then
			container_widget:set_bg(bg_click)
			text_status:set_markup_silently('<span color="' ..
				color.white .. '" font="Ubuntu Nerd Font 11">' .. "on" .. '</span>')
			awful.spawn(command1)
		else
			container_widget:set_bg(color.grey)
			awful.spawn(command2)
			text_status:set_markup_silently('<span color="' ..
				color.white .. '" font="Ubuntu Nerd Font 11">' .. "off" .. '</span>')
		end
	end)

	local final_container = wibox.widget {
		{
			button_container,
			text_button,
			layout = wibox.layout.fixed.horizontal,
		},
		widget = wibox.container.margin,
		top = dpi(3),
		bottom = dpi(3),
		left = dpi(2),
		right = 0,
	}

	return final_container
end

local buttons = {
	wifi = create_button(container.wifi, 'Wifi', true, color.blue, "nmcli radio wifi on", "nmcli radio wifi off"),
	bluetooth = create_button(container.bluetooth, "Bluetooth", false, color.magenta, "", ""),
	dnd = create_button(container.dnd, "DND", false, color.yellow, "", "")
}

--DND Button Functionality
local dnd_on = false
container.dnd:connect_signal("button::press", function()
	dnd_on = not dnd_on
	if dnd_on then
		user.dnd_status = true
	else
		user.dnd_status = false
	end
end)

local button = wibox.widget {
	{
		{
			buttons.wifi,
			buttons.bluetooth,
			buttons.dnd,
			layout = wibox.layout.fixed.vertical
		},
		widget = wibox.container.margin,
		top = dpi(6),
		bottom = dpi(6),
		right = dpi(3),
		left = dpi(3),
	},
	widget = wibox.container.background,
	bg = color.background_lighter,
	forced_width = dpi(202),
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 10)
	end,

}

return button
