--Standard Modules
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Colors
local color = require("layout.dock.color")
local icon_path = "/.icons/Papirus/48x48/places/"
local user = require("popups.user_profile")

local create_button = function(icon, launch_directory, mleft, mright, mtop, mbottom)
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
			awful.spawn.with_shell(user.file_manager .. launch_directory)
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

local directories = {
	home = create_button('user-home.svg', ' ', 2, 0, 0, 2),
	documents = create_button('folder-documents.svg', '~/Documents/', 0, 0, 0, 2),
	downloads = create_button('folder-downloads.svg', '~/Downloads/', 0, 0, 0, 2),
	config = create_button('folder-development.svg', '~/.config', 0, 0, 0, 2),
}

return directories
