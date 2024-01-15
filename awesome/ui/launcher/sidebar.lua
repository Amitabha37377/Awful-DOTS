local awful          = require('awful')
local wibox          = require('wibox')
local beautiful      = require('beautiful')

local dpi            = beautiful.xresources.apply_dpi
local helpers        = require('helpers')
local color          = require("themes.colors")
local user           = require('user')

local sep            = wibox.widget.textbox("       ")
sep.forced_height    = dpi(650)
sep.forced_width     = dpi(70)

local logo           = helpers.margin(helpers.textbox(color.lightblue, "Ubuntu nerd font bold 28", ''), 0, 0, 15, 0)

local create_buttons = function(icon, fg, size)
	local text = helpers.textbox(fg, "Ubuntu nerd font bold " .. size, icon)
	text.valign = 'center'
	text.halign = 'center'

	local text_icon = helpers.margin(
		wibox.widget {
			text,
			widget = wibox.container.place
		},
		10, 10, 10, 10)
	text_icon.forced_height = dpi(50)
	text_icon.forced_width = dpi(50)

	local icon_bg = wibox.widget {
		{
			text_icon,
			widget = wibox.container.place
		},
		widget = wibox.container.background,
		bg = color.bg_dark,
		shape = helpers.rrect(30)
	}

	helpers.add_hover_effect(icon_bg, color.bg_dim, color.bg_light, color.bg_dark)

	return helpers.margin(icon_bg, 0, 0, 0, 10)
end

local sidebar        = wibox.widget {
	{
		{
			{
				logo,
				widget = wibox.container.place
			},
			nil,
			{
				{
					create_buttons('󰿅', color.green, 19),
					create_buttons('󰜉', color.magenta, 22),
					create_buttons('󰐥', color.red, 22),
					layout = wibox.layout.fixed.vertical
				},
				widget = wibox.container.place
			},
			layout = wibox.layout.align.vertical
		},
		sep,
		layout = wibox.layout.stack
	},
	widget = wibox.container.background,
	bg = color.bg_normal,
}

return sidebar
