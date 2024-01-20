local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
local gears = require('gears')

local dpi = beautiful.xresources.apply_dpi
local helpers = require('helpers')
local color = require("themes.colors")

local volume_slider = wibox.widget({
	widget = wibox.widget.slider,
	bar_shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 25)
	end,

	bar_height = dpi(8),
	bar_color = color.mid_dark,
	bar_active_color = color.blue,
	handle_shape = gears.shape.circle,
	handle_color = color.lightblue,
	handle_width = dpi(25),
	handle_border_width = 3,
	handle_border_color = color.bg_dim,
	minimum = 0,
	maximum = 100,
	value = 69,
})

-- Define a timer to update the volume slider value every second
awesome.connect_signal("slider::volume", function()
	awful.spawn.easy_async("amixer sget Master", function(stdout)
		local volume = tonumber(string.match(stdout, "(%d?%d?%d)%%"))
		volume_slider.value = volume
	end)
end)

awesome.emit_signal("slider::volume")

-- awful.spawn.easy_async("amixer sget Master", function(stdout)
-- 	local volume = tonumber(string.match(stdout, "(%d?%d?%d)%%"))
-- 	volume_slider.value = volume
-- end)

-- local volume_slider_timer = gears.timer({
-- 	timeout = 1,
-- 	call_now = true,
-- 	autostart = true,
-- 	callback = update_volume_slider,
-- })

-- Add signal to set the Volume using amixer
volume_slider:connect_signal("property::value", function(slider)
	local volume_level = math.floor(slider.value / 100 * 100)
	awful.spawn("amixer set Master " .. volume_level .. "%")
end)



local icon = helpers.margin(
	helpers.textbox(color.orange, "Ubuntu nerd font bold 30", '󰕾'),
	0, 15, 5, 5
)

local vol_slider = helpers.margin(
	wibox.widget {
		{
			icon,
			volume_slider,
			layout = wibox.layout.fixed.horizontal
		},
		widget = wibox.container.margin,
		-- margins = dpi(10),
		forced_height = dpi(40),
		forced_width = dpi(400),
	},
	30, 30, 0, 1)

vol_slider.forced_width = dpi(450)

return vol_slider
