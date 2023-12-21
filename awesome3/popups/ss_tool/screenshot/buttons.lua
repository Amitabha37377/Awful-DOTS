local awful = require 'awful'
local beautiful = require 'beautiful'
local gears = require 'gears'
local wibox = require 'wibox'
local dpi = beautiful.xresources.apply_dpi

local color = require 'themes.colors'
local helpers = require 'helpers'

local create_button = function(icon)
	local txtbox = helpers.textbox(color.mid_light, "Ubuntu nerd font bold 60", icon)

	local icon_txt = helpers.margin(
		wibox.widget {
			txtbox,
			widget = wibox.container.place
		},
		20, 20, 10, 10)

	icon_txt.forced_width = dpi(150)
	icon_txt.forced_height = dpi(140)

	local btn = wibox.widget {
		icon_txt,
		widget = wibox.container.background,
		bg = color.bg_normal,
		shape = helpers.rrect(8)
	}

	helpers.add_hover_effect(btn, color.blue, color.lightblue, color.bg_normal)

	btn:connect_signal("mouse::enter", function()
		txtbox.markup = helpers.mtext(color.bg_dark, "Ubuntu nerd font bold 60", icon)
	end)

	btn:connect_signal("mouse::leave", function()
		txtbox.markup = helpers.mtext(color.mid_light, "Ubuntu nerd font bold 60", icon)
	end)


	return btn
end

local buttons = {
	fullscreen = create_button('󰇄'),
	select = create_button('󰆞'),
	timer = create_button('󰔚')
}


return buttons
