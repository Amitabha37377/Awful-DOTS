local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local dpi = beautiful.xresources.apply_dpi

local helpers = require('helpers')
local color = require('themes.colors')

local function create_buttons(clr, icon, txt, command)
	local icontxt = helpers.textbox(clr, "Ubuntu nerd font bold 35", icon)
	icontxt.valign = 'center'
	icontxt.halign = 'center'

	local iconbtn = wibox.widget {
		helpers.margin(icontxt, 10, 10, 10, 10),
		widget = wibox.container.background,
		bg = color.bg_normal,
		shape = helpers.rrect(40),
		border_width = dpi(6),
		border_color = color.bg_dim,
		forced_height = dpi(80),
		forced_width = dpi(80),
	}

	local btntxt = helpers.textbox(color.fg_normal, "Ubuntu nerd font 28", txt)
	btntxt.valign = 'center'
	btntxt.halign = 'center'

	local btn = wibox.widget {
		{
			{
				helpers.margin(iconbtn, 25, 10, 0, 0),
				helpers.margin(btntxt, 25, 5, 0, 0),
				layout = wibox.layout.fixed.horizontal
			},
			widget = wibox.container.margin,
			margins = dpi(10)
		},
		widget = wibox.container.background,
		bg = color.bg_dark,
		shape = helpers.rrect(15)
	}

	btn:connect_signal("mouse::enter", function()
		iconbtn.bg = clr
		iconbtn.border_color = color.bg_normal
		icontxt.markup = helpers.mtext(color.bg_normal, "Ubuntu nerd font bold 35", icon)
	end)

	btn:connect_signal("mouse::leave", function()
		iconbtn.bg = color.bg_normal
		iconbtn.border_color = color.bg_dim
		icontxt.markup = helpers.mtext(clr, "Ubuntu nerd font bold 35", icon)
	end)

	helpers.add_hover_effect(btn, color.bg_dim, color.bg_light, color.bg_dark)

	return btn
end

local power = create_buttons(color.red, '⏻', "Shut down", nil)
local logout = create_buttons(color.purple, '󰗼', "Logout", nil)
local reboot = create_buttons(color.orange, '', "Restart", nil)
local lock = create_buttons(color.green, '', "Lock screen", nil)


return wibox.widget { {
	power,
	reboot,
	logout,
	lock,
	layout = wibox.layout.fixed.vertical
},
	widget = wibox.container.margin,
	margins = dpi(15),
	left = dpi(25),
	right = dpi(25)
}
