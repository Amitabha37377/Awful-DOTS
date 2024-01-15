local awful         = require 'awful'
local wibox         = require('wibox')
local beautiful     = require('beautiful')

local dpi           = beautiful.xresources.apply_dpi
local helpers       = require('helpers')
local color_list    = require("themes.colors")

local calendar_wdgt = wibox.widget {
	widget       = wibox.widget.calendar.month,
	date         = os.date("*t"),
	font         = 'Ubuntu nerd font bold 15',
	flex_height  = true,
	start_sunday = true,
	fn_embed     = function(widget, flag, date)
		local focus_widget = wibox.widget {
			text   = date.day,
			align  = "center",
			widget = wibox.widget.textbox,
			font   = 'Ubuntu nerd font bold 15'
		}
		local torender = flag == 'focus' and focus_widget or widget
		if flag == 'header' then
			torender.font = 'Ubuntu Nerd font bold ' .. 15
		end
		if flag == 'weekday' then
			torender.font = 'Ubuntu Nerd font bold ' .. 15
		end

		local colors = {
			header  = color_list.blue,
			focus   = color_list.orange,
			normal  = color_list.fg_normal,
			weekday = color_list.purple,
		}
		local color = colors[flag] or beautiful.fg_normal
		return wibox.widget {

			{
				{
					torender,
					align  = "left",
					widget = wibox.container.place
				},
				margins = dpi(7),
				widget  = wibox.container.margin,

			},
			fg     = color,
			bg     = color_list.bg_normal,
			shape  = helpers.rrect(15),
			-- forced_hight = dpi(300),
			widget = wibox.container.background
		}
	end
}

local wgt           = wibox.widget {
	{
		{
			calendar_wdgt,
			widget = wibox.container.margin,
			margins = dpi(10)
		},
		widget = wibox.container.background,
		bg = color_list.bg_normal,
		shape = helpers.rrect(15)
	},
	widget = wibox.container.margin,
	margins = dpi(10)
}

return wgt
