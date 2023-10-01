--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Custom Modules
local color_list = require("popups.color")

local Separator = wibox.widget.textbox("    ")
Separator.forced_height = 30
Separator.forced_width = 80


---------------------------
--Calendar ----------------
---------------------------

local calendar_wdgt = wibox.widget {
	widget       = wibox.widget.calendar.month,
	date         = os.date("*t"),
	font         = 'Ubuntu nerd font 14',
	flex_height  = true,
	start_sunday = true,
	fn_embed     = function(widget, flag, date)
		local focus_widget = wibox.widget {
			text   = date.day,
			align  = "center",
			widget = wibox.widget.textbox,
			font   = 'Ubuntu nerd font bold 14'
		}
		local torender = flag == 'focus' and focus_widget or widget
		if flag == 'header' then
			torender.font = 'Ubuntu Nerd font bold ' .. 14
		end
		if flag == 'weekday' then
			torender.font = 'Ubuntu Nerd font bold ' .. 14
		end

		local colors = {
			header  = color_list.blue,
			focus   = color_list.green,
			normal  = color_list.white,
			weekday = color_list.magenta,
		}
		local color = colors[flag] or beautiful.fg_normal
		return wibox.widget {

			{
				{
					torender,
					align  = "left",
					widget = wibox.container.place
				},
				margins = dpi(3),
				widget  = wibox.container.margin,

			},
			fg     = color,
			bg     = color_list.background_lighter,
			-- shape  = helpers.mkroundedrect(),
			-- forced_hight = dpi(300),
			widget = wibox.container.background
		}
	end
}

------------------
--Clock-----------
------------------

local sep = wibox.widget {
	markup       = '<span color="' ..
			color_list.green .. '" font="Ubuntu Nerd Font bold 10">' .. '' .. '</span>',
	font         = "Ubuntu Nerd Font 14",
	widget       = wibox.widget.textbox,
	fg           = color_list.white,
	forced_width = dpi(80),
	align        = 'center',
}

local hour_clock = wibox.widget.textclock(
	'<span color="' .. color_list.yellow .. '" font="Ubuntu Nerd Font Bold 36"> %H </span>', 10)

local minute_clock = wibox.widget.textclock(
	'<span color="' .. color_list.yellow .. '" font="Ubuntu Nerd Font Bold 36"> %M </span>', 10)

local date_text = wibox.widget.textclock(
	'<span color="' .. color_list.magenta .. '" font="Ubuntu Nerd Font Bold 14"> %a, %d </span>', 10)

---------------------------------
--Main widget--------------------
---------------------------------

local calendar = wibox.widget {
	{
		{
			{
				{
					{
						calendar_wdgt,
						widget = wibox.container.margin,
						margins = dpi(8),
						layout = wibox.layout.fixed.horizontal
					},
					widget = wibox.container.background,
					bg = color_list.background_lighter,
					forced_width = dpi(330),

					forced_hight = dpi(300),
				},
				widget = wibox.container.margin,
				-- margins = dpi(7),
				top = dpi(7),
				bottom = dpi(7),
				left = dpi(10),
				right = dpi(0),
				forced_width = dpi(300),

			},
			widget = wibox.container.background,
			bg = color_list.background_lighter,
			shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, 10)
			end,
		},
		widget = wibox.container.margin,
		margins = dpi(12)
	},
	{
		{
			{
				{
					{
						-- hour_text,
						hour_clock,
						sep,
						minute_clock,
						Separator,
						date_text,
						layout = wibox.layout.fixed.vertical
					},
					widget = wibox.container.place,
				},
				widget = wibox.container.margin,
				margins = 12,

				forced_hight = dpi(300),
			},
			widget = wibox.container.background,
			bg = color_list.background_lighter,
			shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, 10)
			end,

		},
		widget = wibox.container.margin,
		top = dpi(12),
		bottom = dpi(12),
		left = 0,
		right = dpi(12),
	},
	layout = wibox.layout.fixed.horizontal


}

return calendar
