--Standard Modules
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local color = require("themes.colors")
local dpi = beautiful.xresources.apply_dpi

local separator = wibox.widget.textbox("   ")
local icon_path = os.getenv("HOME") .. "/.config/awesome/assets/others/"

--Popup Menus

local create_button = function(icon)
	--Imagebox for icon
	local icon_image = wibox.widget {
		widget = wibox.widget.imagebox,
		image = icon_path .. icon .. ".png",
		resize = true,
	}

	--Main button
	local created_button = wibox.widget {
		{
			icon_image,
			margins = dpi(6),
			widget = wibox.container.margin
		},
		bg = color.bg_normal,
		shape = gears.shape.rounded_rect,
		widget = wibox.container.background,
	}
	return created_button
end

local screenshot = create_button('screenshot')
local settings = create_button('settings')
local music = create_button('music-icon')

settings:connect_signal("button::press", function()
	awesome.emit_signal("control::toggle")
	awesome.emit_signal("nc::close")
end)

music:connect_signal("button::press", function()
	awesome.emit_signal("mplayer::toggle")
end)


screenshot:connect_signal("button::press", function(_, _, _, button)
	if button == 3 then
		awful.spawn.with_shell(
			'scrot /tmp/screenshot.png && convert /tmp/screenshot.png -resize 20% /tmp/resized_screenshot.png && notify-send -i /tmp/resized_screenshot.png "Screenshot Captured" && cp /tmp/screenshot.png ~/Pictures/file1_`date +"%Y%m%d_%H%M%S"`.png && rm /tmp/resized_screenshot.png && rm /tmp/screenshot.png'
		)
	elseif button == 1 then
		awesome.emit_signal("ss_tool::toggle")
	end
end)

--Main Window
local grouped_buttons = wibox.widget {
	{
		{
			separator,
			music,
			separator,
			settings,
			separator,
			screenshot,
			separator,

			layout = wibox.layout.fixed.horizontal,
		},
		widget = wibox.container.background,
		shape  = gears.shape.rounded_rect,
		bg     = color.bg_normal
	},
	left   = dpi(3),
	right  = dpi(15),
	top    = dpi(3),
	bottom = dpi(3),
	widget = wibox.container.margin

}

return grouped_buttons
