local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local color = require('themes.colors')
local helpers = require('helpers')

local header = require('popups.control_center.header')
local buttons = require('popups.control_center.buttons')
local vol_slider = require('popups.control_center.vol_slider')
local bright_slider = require('popups.control_center.bright_slider')
local notif_center = require('popups.control_center.notif_center')

local cc = wibox.widget {
	header,
	buttons,
	bright_slider,
	vol_slider,
	-- notif_center,
	layout = wibox.layout.fixed.vertical,
}

local control = awful.popup {
	-- screen = s,
	widget = wibox.container.background,
	ontop = true,
	bg = "#00000000",
	visible = false,
	placement = function(c)
		awful.placement.top_right(c,
			{ margins = { top = dpi(45), bottom = dpi(0), left = dpi(8), right = dpi(8) } })
	end,
}

control:setup({
	{
		cc,
		widget = wibox.container.margin,
		bottom = dpi(40),
	},
	widget = wibox.container.background,
	bg = color.bg_dim,
	shape = helpers.rrect(15)
})

awesome.connect_signal("control::toggle", function()
	control.visible = not control.visible
end)

awesome.connect_signal("control::on", function()
	control.visible = true
end)

awesome.connect_signal("control::off", function()
	control.visible = false
end)
