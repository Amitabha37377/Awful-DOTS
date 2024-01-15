local awful      = require('awful')
local beautiful  = require('beautiful')
local wibox      = require('wibox')
local dpi        = beautiful.xresources.apply_dpi

local helpers    = require('helpers')
local color      = require('themes.colors')

local sep        = wibox.widget.textbox(" ")
-- sep.forced_height = dpi(650)
sep.forced_width = dpi(500)

--modules
local header     = require('popups.powermenu.header')
local footer     = require('popups.powermenu.uptime')
local buttons    = require('popups.powermenu.buttons')


local popup = awful.popup {
	screen = s,
	bg = "#00000000",
	widget = wibox.container.background,
	shape = helpers.rrect(0),
	ontop = true,
	visible = false,
	placement = function(c)
		awful.placement.centered(c,
			{ margins = { top = dpi(0), bottom = dpi(0), left = dpi(0), right = dpi(0) } })
	end,
}

popup:setup(
	{
		{
			{
				{
					{
						header,
						buttons,
						footer,
						layout = wibox.layout.align.vertical,
					},
					sep,
					layout = wibox.layout.stack
				},
				widget = wibox.container.background,
				bg = color.bg_dark,
				shape = helpers.rrect(15)
			},
			widget = wibox.container.place
		},
		widget = wibox.container.background,
		forced_height = dpi(1080),
		forced_width = dpi(1920),
		bg = color.bg_normal .. '90'
	})

popup:connect_signal("button::release", function(_, _, _, button)
	if button == 3 then
		popup.visible = false
	end
end)

awesome.connect_signal("widget::powermenu", function()
	popup.visible = not popup.visible
end)
