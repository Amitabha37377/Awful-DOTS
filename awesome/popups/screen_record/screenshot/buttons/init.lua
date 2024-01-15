local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local color = require("popups.color")

local function create_button(img, hover_img)
	--Image widget
	local image = wibox.widget {
		widget = wibox.widget.imagebox,
		image = os.getenv("HOME") .. "/.config/awesome/popups/screen_record/assets/" .. img .. ".png",
		resize = true,
		opacity = 1,
	}

	local button = wibox.widget {
		{
			{
				{
					image,
					layout = wibox.layout.fixed.vertical
				},
				left   = dpi(25),
				right  = dpi(25),
				top    = dpi(25),
				bottom = dpi(25),
				widget = wibox.container.margin
			},
			layout = wibox.container.place
		},
		bg = color.background_lighter,
		shape = gears.shape.rounded_rect,
		widget = wibox.container.background,
		forced_height = dpi(140),
		forced_width = dpi(150),
	}

	button:connect_signal("mouse::enter", function()
		button.bg = color.blueish_white
		image.image = os.getenv("HOME") .. "/.config/awesome/popups/screen_record/assets/" .. hover_img .. ".png"
	end)

	button:connect_signal("mouse::leave", function()
		image.image = os.getenv("HOME") .. "/.config/awesome/popups/screen_record/assets/" .. img .. ".png"
		button.bg = color.background_lighter
	end)

	button:connect_signal("button::press", function()
		button.bg = color.blue
	end)

	button:connect_signal("button::release", function()
		button.bg = color.blueish_white
	end)

	return button
end


local ss_buttons = {
	full = create_button('full', 'full-hover'),
	selection = create_button('selection', 'selection-hover'),
	timed = create_button('clock', 'clock-hover')
}

return ss_buttons
