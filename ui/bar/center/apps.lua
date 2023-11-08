local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi
local helpers = require('helpers')
local color = require("themes.colors")
local user = require('user')


local create_button = function(icon, command)
	local buttons = wibox.widget {
		{
			{
				image = user.icon_path .. icon .. '.svg',
				resize = true,
				widget = wibox.widget.imagebox,
			},
			widget = wibox.container.margin,
			margins = dpi(3)
		},
		widget = wibox.container.background,
		bg = color.bg_dark,
		shape = helpers.rrect(dpi(4)),
		id = 'background'
	}

	local imgbox = wibox.widget {
		buttons,
		widget = wibox.container.margin,
		left = dpi(5),
		right = dpi(5)
	}

	helpers.add_hover_effect(buttons, color.bg_normal, color.bg_light, color.bg_dark)

	buttons:connect_signal("button::release", function(_, _, _, button)
		if button == 1 then
			awful.spawn(command)
		end
	end)

	return imgbox
end

local apps = {
	term = create_button('terminal', user.terminal),
	firefox = create_button('firefox', 'firefox'),
	discord = create_button('discord', 'flatpak run com.discordapp.Discord'),
	telegram = create_button('telegram', 'telegram-desktop'),
	code = create_button('code', 'code'),
	gimp = create_button('gimp', 'gimp'),
	files = create_button('folder_doc_q4os_startmenu', user.file_manager)
}

return apps
