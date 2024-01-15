-- Modules
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local color = require("popups.color")
local dpi = beautiful.xresources.apply_dpi

--Spacer

-----------------------------
--Volume Slider Widget
-----------------------------
local volume_slider = wibox.widget({
	widget = wibox.widget.slider,
	bar_shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 25)
	end,

	bar_height = dpi(25),
	bar_color = color.white,
	bar_active_color = color.blue,
	handle_shape = gears.shape.circle,
	handle_color = "#4682b8",
	handle_width = dpi(25),
	handle_border_width = 1,
	handle_border_color = "#4682b8",
	minimum = 0,
	maximum = 100,
	value = 69,
})

-- Define a timer to update the volume slider value every second
local update_volume_slider = function()
	awful.spawn.easy_async("amixer sget Master", function(stdout)
		local volume = tonumber(string.match(stdout, "(%d?%d?%d)%%"))
		volume_slider.value = volume
	end)
end

local volume_slider_timer = gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = update_volume_slider,
})

-- Add signal to set the Volume using amixer
volume_slider:connect_signal("property::value", function(slider)
	local volume_level = math.floor(slider.value / 100 * 100)
	awful.spawn("amixer set Master " .. volume_level .. "%")
end)

local volume_container = {
	{
		{
			id = "volume",
			widget = wibox.widget.imagebox,
			image = os.getenv("HOME") .. "/.config/awesome/popups/control_center/assets/audio2.png",
			resize = true,
			opacity = 1,
		},
		widget = wibox.container.margin,
		top = 0,
		bottom = dpi(10),
		right = 0,
		left = dpi(5)
	},
	{
		volume_slider,
		widget = wibox.container.margin,
		top = dpi(1),
		bottom = dpi(10),
		right = dpi(15),
		left = dpi(5),
		forced_width = dpi(360),
		forced_height = dpi(70),
	},
	layout = wibox.layout.fixed.horizontal,
	forced_width = dpi(410),
	forced_height = dpi(50),
}


return volume_container
