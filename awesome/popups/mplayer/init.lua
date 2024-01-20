local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local dpi = beautiful.xresources.apply_dpi

local helpers = require('helpers')
local color = require('themes.colors')

local sep = wibox.widget.textbox(" ")
sep.forced_height = dpi(500)
sep.forced_width = dpi(350)

local h = awful.screen.focused().workarea.height
local w = awful.screen.focused().workarea.width + dpi(50) --Bar width


local titlebar = require 'popups.mplayer.titlebar'
local comps = require("popups.mplayer.components")

local popup = awful.popup {
	screen = s,
	bg = "#00000000",
	widget = wibox.container.background,
	x = dpi(w - 410),
	y = dpi(45),
	shape = helpers.rrect(0),
	ontop = true, visible = false,
}

popup:setup({
	{
		{
			titlebar,
			comps,
			layout = wibox.layout.fixed.vertical
		},
		sep,
		layout = wibox.layout.stack
	},
	widget = wibox.container.background,
	bg = color.bg_normal,
	shape = helpers.rrect(10),
	border_width = dpi(3),
	border_color = color.bg_dark
})

local drag = false

titlebar:connect_signal("button::press", function()
	drag = true
end)

popup:connect_signal("button::release", function()
	drag = false
end)


popup:connect_signal("mouse::move", function()
	if drag then
		mousegrabber.run(function(mouse)
			popup.x = mouse.x - 140
			popup.y = mouse.y - 140
		end, "arrow")
	end
end)


--Signals------------
awesome.connect_signal("mplayer::open", function()
	popup.visible = true
end)

awesome.connect_signal("mplayer::close", function()
	popup.visible = false
end)

awesome.connect_signal("mplayer::toggle", function()
	popup.visible = not popup.visible
end)

awesome.connect_signal("mplayer::pin_top", function()
	popup.x = dpi(w - 410)
	popup.y = dpi(45)
end)

awesome.connect_signal("mplayer::pin_bottom", function()
	popup.x = dpi(w - 410)
	popup.y = dpi(h - 520)
end)
