local awful          = require 'awful'
local wibox          = require('wibox')
local beautiful      = require('beautiful')

local dpi            = beautiful.xresources.apply_dpi
local helpers        = require('helpers')
local color          = require("themes.colors")

local user           = require('user')
local iconpath       = os.getenv("HOME") .. '/.config/awesome/assets/weather_icons/'

--------------------------
--Base_widgets------------
--------------------------
local city_text      = helpers.textbox(color.lightblue, "Ubuntu nerd font bold 12", " Earth (probably)")
local country_text   = helpers.textbox(color.fg_normal, "Ubuntu nerd font bold 12", ",SS")
local weather_txt    = helpers.textbox(color.lightblue, "Ubuntu nerd font bold 12", "Loading...")
local temp_txt       = helpers.textbox(color.fg_normal, "Ubuntu nerd font bold 30", " " .. '°C')

local icon_humid     = helpers.textbox(color.blue, "Ubuntu nerd font bold 16", "󱪅 ")
local icon_wind      = helpers.textbox(color.blue, "Ubuntu nerd font bold 16", " ")
local icon_feelslike = helpers.textbox(color.blue, "Ubuntu nerd font bold 16", "󱤋 ")

local NA             = helpers.textbox(color.fg_normal, "Ubuntu nerd font 14", "N/A")

local weath_image    = helpers.imagebox(iconpath .. 'weather-error.svg', 70, 70)

--Bottom containers
local container      = function(wgt1, wgt2)
	return wibox.widget {
		{
			{
				{
					wgt1,
					nil,
					wgt2,
					layout = wibox.layout.align.horizontal
				},
				widget       = wibox.container.margin,
				forced_width = dpi(110),
				left         = dpi(10),
				right        = dpi(10),
				top          = dpi(5),
				bottom       = dpi(5)
			},
			widget = wibox.container.background,
			bg = color.bg_light,
			shape = helpers.rrect(10)
		},
		widget = wibox.container.margin,
		margins = dpi(0) }
end



local wgt = wibox.widget {
	{
		{
			{
				helpers.margin({
						city_text,
						nil,
						weather_txt,
						layout = wibox.layout.align.horizontal
					},
					5, 5, 10, 10),
				helpers.margin({
						temp_txt,
						nil,
						weath_image,
						layout = wibox.layout.align.horizontal
					},
					10, 5, 5, 10),
				helpers.margin({
						{
							helpers.margin(container(icon_humid, NA), 5, 12, 0, 0),
							helpers.margin(container(icon_feelslike, NA), 12, 12, 0, 0),
							helpers.margin(container(icon_wind, NA), 12, 5, 0, 0),
							layout = wibox.layout.fixed.horizontal
						},
						widget = wibox.container.place
					},
					0, 0, 0, 10),
				layout = wibox.layout.fixed.vertical
			},
			widget = wibox.container.margin,
			margins = dpi(20)
		},
		widget = wibox.container.background,
		bg = color.bg_normal,
		shape = helpers.rrect(15)
	},
	widget = wibox.container.margin,
	margins = dpi(10),
	forced_width = dpi(450)
}

return wgt
