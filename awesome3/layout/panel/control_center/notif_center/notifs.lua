local awful              = require('awful')
local wibox              = require('wibox')
local beautiful          = require('beautiful')
local gears              = require('gears')
local naughty            = require('naughty')

local dpi                = beautiful.xresources.apply_dpi
local helpers            = require('helpers')
local color              = require("themes.colors")

local Separator          = wibox.widget.textbox("    ")
Separator.forced_height  = dpi(20)

local notifscontainer    = wibox.widget {
	spacing = dpi(5),
	layout = require('modules.overflow').vertical,
	scrollbar_enabed = false,
	step = 70,
	forced_width = dpi(410),
	-- scrollbar_width = 10,

}

local notifsempty        = wibox.widget {
	nil,
	{
		nil,
		{
			{
				{
					{
						widget = wibox.widget.imagebox,
						image = os.getenv("HOME") .. '/.config/awesome/assets/control_center/bell.png',
						resize = true,
						forced_height = dpi(160),
						forced_width = dpi(160)
					},
					widget = wibox.container.place
				},
				Separator,
				{
					-- text = "No Notifications",
					markup = '<span color="' ..
							color.lightblue .. '" font="Ubuntu Nerd Font Bold 20">' .. 'No Notification Yet\n\n' .. '</span>',
					align = "center",
					valign = "center",
					widget = wibox.widget.textbox
				},
				layout = wibox.layout.fixed.vertical
			},
			widget = wibox.container.place
		},
		layout = wibox.layout.align.horizontal
	},
	forced_height = dpi(550), --fix this?
	forced_width = dpi(410),
	layout = wibox.layout.align.vertical
}

local notifsemptyvisible = true

removenotif              = function(notif)
	notifscontainer:remove_widgets(notif)

	if #notifscontainer.children == 0 then
		notifscontainer:insert(1, notifsempty)
		notifsemptyvisible = true
	end
end

local createnotif        = function(Notifications)
	local notif = wibox.widget { {
		{
			{

				{
					{
						helpers.margin(
							helpers.textbox(color.fg_normal, "Ubuntu nerd font bold 13", Notifications.title),
							20, 0, 0, 5),
						helpers.margin(
							helpers.textbox(color.fg_normal, "Ubuntu nerd font 13", Notifications.message),
							20, 0, 0, 5),
						layout = wibox.layout.fixed.vertical,
					},
					widget = wibox.container.place,
					forced_height = dpi(80),
					forced_width = Notifications.icon == nil and dpi(410)
							or Notifications.title == "Connection Established" and dpi(410)
							or Notifications.title == "Disconnected" and dpi(410)
							or dpi(250),
					halign = 'left'
				},
				nil,
				{
					{
						widget        = wibox.widget.imagebox,
						image         = Notifications.icon,
						-- forced_height = dpi(60),
						forced_height = dpi(50),
					},
					widget = wibox.container.margin,
					left = 10,
					right = dpi(20),
					top = dpi(10),
					bottom = dpi(10)
				},
				layout = wibox.layout.align.horizontal,
			},
			widget = wibox.container.margin,
			margins = dpi(10)
		},
		widget = wibox.container.background,
		bg = color.bg_dim,
		shape = helpers.rrect(8)
	},
		widget = wibox.container.margin,
		left = dpi(10),
		rigth = 0,
		top = dpi(10),
		bottom = dpi(10)

	}

	notif:connect_signal("button::release", function(_, _, _, button)
		if button == 3 then
			_G.removenotif(notif)
		end
	end)


	return notif
end

notifscontainer:insert(1, notifsempty)

naughty.connect_signal("request::display", function(n)
	if #notifscontainer.children == 1 and notifsemptyvisible then
		notifscontainer:reset(notifscontainer)
		notifsemptyvisible = false
	end

	notifscontainer:insert(1, createnotif(n))
end)

awesome.connect_signal("notifs::clear", function()
	notifscontainer:reset()
	notifscontainer:insert(1, notifsempty)
	notifsemptyvisible = true
end)

return notifscontainer
