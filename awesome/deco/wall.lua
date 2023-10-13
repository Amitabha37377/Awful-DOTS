local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local user = require("popups.user_profile")



local global_wallpaper = awful.wallpaper {
	screen = s,
	widget = {
		horizontal_fit_policy = "fit",
		vertical_fit_policy   = "fit",
		{
			{
				{
					image                 = user.wallpaper,
					resize                = true,
					widget                = wibox.widget.imagebox,
					forced_height         = dpi(1080 - 35),
					forced_width          = dpi(1920),
					horizontal_fit_policy = "fit",
					vertical_fit_policy   = "fit"
				},
				widget = wibox.container.background,
				bg = "#1a1b26",
				shape = function(cr, width, height)
					gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, 12)
				end,
				forced_height = dpi(1045),

			},
			widget = wibox.container.background,
			bg = "#1a1b26"
		},
		valign = "bottom",
		halign = "center",
		tiled  = false,
		widget = wibox.container.tile,
	}
}

screen.connect_signal("request::wallpaper", function()
	global_wallpaper.screens = screen
end)
