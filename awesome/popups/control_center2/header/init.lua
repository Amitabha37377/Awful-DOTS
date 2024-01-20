local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
local gears = require('gears')

local dpi = beautiful.xresources.apply_dpi
local helpers = require('helpers')
local color = require("themes.colors")
local user = require("user")

local usr_img = helpers.imagebox(user.user_img, 60, 60)
usr_img.clip_shape = helpers.rrect(45)

local img = helpers.margin(usr_img, 0, 15, 0, 0)

local name = wibox.widget {
	{
		helpers.margin(
			helpers.textbox(color.lightblue, "Ubuntu nerd font bold 15", user.name),
			0, 0, 4, 0
		),
		helpers.margin(
			helpers.textbox(color.mid_light, "Ubuntu nerd font bold 13", user.host),
			0, 0, 0, 4
		),
		layout = wibox.layout.fixed.vertical
	},
	widget = wibox.container.place
}

local create_button = function(fg, icon)
	local btn = helpers.margin(
		wibox.widget {
			helpers.textbox(fg, "Ubuntu nerd font 18", icon),
			widget = wibox.container.place
		},
		8, 8, 8, 8
	)

	btn.forced_height = dpi(50)
	btn.forced_width = dpi(50)

	local button_bg = wibox.widget {
		btn,
		widget = wibox.container.background,
		bg = color.bg_dark,
		border_width = 3,
		border_color = color.bg_dim,
		shape = helpers.rrect(40, 40)
	}

	local button = wibox.widget {
		button_bg,
		widget = wibox.container.place,
		valign = 'center'
	}
	helpers.add_hover_effect(button_bg, color.bg_normal, color.bg_light, color.bg_dark)
	return helpers.margin(button, 5, 0, 0, 0)
end

local power = create_button(color.red, '')
local bell = create_button(color.orange, '󰂚')

bell:connect_signal("button::release", function()
	awesome.emit_signal("nc::open")
	awesome.emit_signal("control::off")
end)


local main = wibox.widget {
	{
		{
			{
				{
					img,
					name,
					spacing = dpi(5),
					layout = wibox.layout.fixed.horizontal
				},
				widget = wibox.container.margin,
				-- left = dpi(10),
				-- top = dpi(10)
			},
			nil,
			{
				{
					{
						bell,
						power,
						layout = wibox.layout.fixed.horizontal
					},
					layout = wibox.layout.fixed.vertical,
				},
				widget = wibox.container.place
			},
			layout = wibox.layout.align.horizontal
		},
		widget = wibox.container.margin,
		left = dpi(15),
		right = dpi(25),
		top = dpi(15),
		bottom = dpi(15)
	},
	widget = wibox.container.background,
	bg = color.bg_normal,
	shape = helpers.rrect(8)
}

return helpers.margin(main, 25, 25, 25, 15)
