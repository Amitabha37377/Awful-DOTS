--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi


--Custom Modules
local color = require("popups.color")
local container = require("popups.control_center.buttons.container")

--Separator
local Separator = wibox.widget.textbox("    ")
Separator.forced_height = dpi(4)

--Function
local create_button = function(container_widget, text, command1, command2, bg_click)
	--Status textbox
	local status = wibox.widget {
		markup = '<span color="' .. color.white .. '" font="Ubuntu Nerd Font 11">' .. "Off" .. '</span>',
		font = "Ubuntu Nerd Font Bold 14",
		widget = wibox.widget.textbox,
		fg = color.white
	}

	--text
	local button_text = wibox.widget {
		{
			{
				markup = '<span color="' ..
						color.blueish_white .. '" font="Ubuntu Nerd Font bold 11">' .. text .. '</span>',
				font = "Ubuntu Nerd Font Bold 14",
				widget = wibox.widget.textbox,
				fg = color.white
			},
			Separator,
			status,
			layout = wibox.layout.fixed.vertical

		},
		widget = wibox.container.margin,
		top = dpi(20),
		bottom = dpi(18),
		right = dpi(8),
		left = dpi(8),
		forced_height = dpi(80)
	}
	--Image
	local button_image = wibox.widget {
		container_widget,
		widget = wibox.container.margin,
		top = dpi(13),
		bottom = dpi(13),
		right = dpi(10),
		left = dpi(7),
		forced_height = dpi(80)
	}

	--Functionality
	local onstatus = false
	button_image:connect_signal("button::press", function()
		onstatus = not onstatus
		if onstatus then
			container_widget:set_bg(bg_click)
			status:set_markup_silently('<span color="' ..
				color.white .. '" font="Ubuntu Nerd Font 11">' .. "On" .. '</span>')
			awful.spawn.with_shell(command1)
		else
			container_widget:set_bg(color.grey)
			status:set_markup_silently('<span color="' ..
				color.white .. '" font="Ubuntu Nerd Font 11">' .. "Off" .. '</span>')
			awful.spawn.with_shell(command2)
		end
	end)

	--Main button
	local button = wibox.widget {
		{
			{
				{
					{
						button_image,
						button_text,
						layout = wibox.layout.fixed.horizontal,
					},
					widget = wibox.container.margin,
					top = dpi(3),
					bottom = dpi(6),
					left = dpi(2),
					right = 0,
				},
				layout = wibox.layout.fixed.vertical
			},
			widget = wibox.container.margin,
			top = dpi(3),
			bottom = dpi(3),
			right = dpi(3),
			left = dpi(3),
		},
		widget = wibox.container.background,
		bg = color.background_lighter,
		-- forced_height = 60,
		forced_width = dpi(202),
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 10)
		end,
	}

	return button
end

local right_buttons = {
	silent = create_button(container.silent, "Silent Mode", "amixer set Master 0%", "amixer set Master 69%", "#5baddd"),
	nightmode = create_button(container.dark, "Night Mode", 'redshift -l 0:0 -t 4500:4500 -r',
		"redshift -x && killall redshift", "#5680b8")
}

return right_buttons
