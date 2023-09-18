-- Modules
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local color = require("popups.color")
local dpi = beautiful.xresources.apply_dpi

--Spacer
local separator = wibox.widget.textbox("    ")

-----------------------------
--Brightness Slider Widget
-----------------------------
local brightness_slider = wibox.widget({
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
	minimum = 5,
	maximum = 100,
	-- value = tonumber(io.popen("light -G"):read("*all")),
	value = 69
})

--Update brightness value
local update_brightness_slider = function()
	awful.spawn.easy_async("light -G", function(stdout)
		local brightness = tonumber(stdout)
		brightness_slider.value = brightness
	end)
end

local brightness_slider_timer = gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = update_brightness_slider,
})



--FUnctionality of Brightness Slider
brightness_slider:connect_signal("property::value", function(slider)
	local brightness_level = math.floor(slider.value / 100 * 100)
	awful.spawn.easy_async("light -S " .. brightness_level, function()
	end)
end)

local brightness_container = {
	{
		{
			id = "brightness",
			widget = wibox.widget.imagebox,
			image = os.getenv("HOME") .. "/.config/awesome/popups/control_center/assets/brightness2.png",
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
		brightness_slider,
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


return brightness_container
