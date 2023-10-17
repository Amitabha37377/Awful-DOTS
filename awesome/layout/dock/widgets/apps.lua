--Standard Modules
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Colors
local color = require("layout.dock.color")
local user = require("popups.user_profile")
local icon_path = user.icon_theme_path


local create_button = function(icon, launch_app, mleft, mright, mtop, mbottom)
	local button = wibox.widget {
		{
			{
				widget = wibox.widget.imagebox,
				image = os.getenv("HOME") .. icon_path .. icon,
				resize = true,
				opacity = 1,
			},
			left   = dpi(mleft),
			right  = dpi(mright),
			top    = dpi(mtop),
			bottom = dpi(mbottom),
			widget = wibox.container.margin
		},
		bg = color.background_dark,
		shape = gears.shape.rounded_rect,
		widget = wibox.container.background,
		forced_height = dpi(48),
		forced_width = dpi(48),
	}

	--Open app on click
	button:connect_signal("button::press", function(_, _, _, button)
		if button == 1 then
			awful.spawn.with_shell(launch_app)
		end
	end)


	--Hover highlight effects
	button:connect_signal("mouse::enter", function()
		button.bg = color.background_lighter
	end)

	button:connect_signal("mouse::leave", function()
		button.bg = color.background_dark
	end)

	button:connect_signal("button::press", function()
		button.bg = color.background_morelight
	end)

	button:connect_signal("button::release", function()
		button.bg = color.background_lighter
	end)

	return button
end

local apps = {
	firefox = create_button('firefox.svg', 'firefox', 1, 1, 3, 3),
	vokoscreenNG = create_button('vokoscreenNG.svg', 'vokoscreenNG', 3, 3, 3, 3),
	discord = create_button('discord.svg', "flatpak run com.discordapp.Discord", 1, 1, 1, 1),
	gimp = create_button('gimp.svg', 'gimp', 1, 1, 3, 3),
	vscode = create_button('code.svg', 'code', 1, 1, 3, 3),
	only_office = create_button('onlyoffice-desktopeditors.svg', 'flatpak run org.onlyoffice.desktopeditors', 2, 2, 3, 3),
	telegram = create_button('telegram.svg', 'telegram-desktop', 1, 1, 1, 1),
	term = create_button('terminal.svg', user.terminal, 2, 2, 3, 3),
	unity = create_button('unityhub.svg', 'unityhub', 1, 1, 1, 1),
	keepassxc = create_button('keepassxc.svg', 'keepassxc', 1, 1, 2, 2),
	gpick = require("popups.color_picker")
	-- gpick = create_button('gpick.svg', 'gpick', 4, 0, 4, 4)
}

-- apps.gpick:connect_signal("button::release", function()
-- 	colorpicker.visible = not colorpicker.visible
-- end)

return apps
