--Standard Modules
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi


--Custom Modules
local user = require("popups.user_profile")
local color = require("popups.color")

--Username
local username = wibox.widget {
	{
		-- text = user.name,
		markup = '<span color="' .. color.blueish_white .. '" font="Ubuntu Nerd Font Bold 14">' .. user.name .. '</span>',
		font = "Ubuntu Nerd Font Bold 14",
		widget = wibox.widget.textbox,
		fg = color.white
	},
	widget = wibox.container.margin,
	top = dpi(5),
	bottom = dpi(5),
	right = dpi(5),
	left = dpi(5),
}

--UserImage
local image = wibox.widget {
	{
		image = user.image_path,
		widget = wibox.widget.imagebox,
		resize = true,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 20)
		end,

	},
	widget = wibox.container.margin,
	top = dpi(3),
	bottom = dpi(3),
	right = dpi(10),
	left = dpi(7),
	forced_height = dpi(40)
}

--Main Widget
local profile = wibox.widget {
	{
		{
			image,
			username,
			layout = wibox.layout.fixed.horizontal,
		},
		widget = wibox.container.margin,
		top = dpi(3),
		bottom = dpi(3),
		right = dpi(3),
		left = dpi(3),
	},
	widget = wibox.container.background,
	bg = color.background_lighter,
	forced_width = dpi(300),
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 10)
	end,

}

return profile
