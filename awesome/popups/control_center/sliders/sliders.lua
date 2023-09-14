local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi

-- Custom modules
local color = require("popups.color")
local volume_slider = require("popups.control_center.sliders.volume_slider")
local brightness_slider = require("popups.control_center.sliders.brightness_slider")


local create_slider = function(text, slider_widget)
	--Text
	local textbox = wibox.widget {
		{
			markup = '<span color="' ..
				color.blueish_white .. '" font="Ubuntu Nerd Font bold 11">' .. text .. '</span>',
			font = "Ubuntu Nerd Font Bold 14",
			widget = wibox.widget.textbox,
			fg = color.white
		},
		widget = wibox.container.margin,
		top = dpi(10),
		bottom = dpi(12),
		right = dpi(8),
		left = dpi(8),
	}

	--Main Container
	local slider = wibox.widget {
		{
			{
				{
					{
						textbox,
						slider_widget,
						layout = wibox.layout.fixed.vertical,
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
		forced_width = dpi(410),
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 10)
		end,
	}

	return slider
end

local sliders = {
	volume = create_slider("Volume", volume_slider),
	brightness = create_slider("Brightness", brightness_slider)
}

return sliders
