local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local color = require("popups.color")
local text = require("popups.powermenu.text")

local function create_button(img, hover_img, description, command, hover_color)
	--Imagebox
	local image = wibox.widget {
		widget = wibox.widget.imagebox,
		image = os.getenv("HOME") .. "/.config/awesome/popups/powermenu/assets/" .. img .. ".png",
		resize = true,
		opacity = 1,
	}

	--Main Widget
	local buttons = wibox.widget {
		{
			image,
			left   = dpi(35),
			right  = dpi(35),
			top    = dpi(35),
			bottom = dpi(35),
			widget = wibox.container.margin
		},
		bg = color.background_dark,
		shape = gears.shape.rounded_rect,
		widget = wibox.container.background,
		forced_height = dpi(150),
		forced_width = dpi(150),
		border_width = dpi(5),
		border_color = color.grey
	}

	--Functionality
	buttons:connect_signal("mouse::enter", function()
		buttons.border_color = hover_color
		image.image = os.getenv("HOME") .. "/.config/awesome/popups/powermenu/assets/" .. hover_img .. ".png"
		text:set_markup_silently('<span color="' ..
			hover_color .. '" font="Ubuntu Nerd Font bold 28">' .. description .. '</span>')
	end)
	--
	buttons:connect_signal("mouse::leave", function()
		buttons.border_color = color.grey
		image.image = os.getenv("HOME") .. "/.config/awesome/popups/powermenu/assets/" .. img .. ".png"
		text:set_markup_silently('<span color="' ..
			color.white .. '" font="Ubuntu Nerd Font 28">' .. " " .. '</span>')
	end)


	buttons:connect_signal("button::press", function(_, _, _, button)
		if button == 1 then
			awful.spawn.with_shell(command)
			awesome.emit_signal("widget::powermenu")
		end
	end)

	return buttons
end

local powermenu_buttons = {
	lock = create_button('lock', 'lock-hover', 'Lock Screen', ' ', color.green),
	logout = create_button('logout', 'logout-hover', 'Logout', '', color.magenta),
	reboot = create_button('restart', 'restart-hover', 'Reboot', 'reboot', color.yellow),
	shutdown = create_button('power', 'power-hover', 'Power Off', 'shutdown -h now', color.red),
	sleep = create_button('power-sleep', 'power-sleep-hover', 'Sleep', '', color.cyan)
}

powermenu_buttons.logout:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		awesome.quit()
	end
end)

powermenu_buttons.lock:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		awesome.emit_signal("screen::lock")
	end
end)

powermenu_buttons.sleep:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		awesome.emit_signal("screen::lock")
		awful.spawn("systemctl suspend")
	end
end)




return powermenu_buttons
