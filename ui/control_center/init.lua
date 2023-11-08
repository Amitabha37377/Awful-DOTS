local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi
local helpers = require('helpers')
local color = require("themes.colors")

local bg_blank = wibox.widget.textbox("   ")
bg_blank.forced_height = dpi(700)
bg_blank.forced_width = dpi(480)

---------------------------
--Modules------------------
---------------------------
local header = require("ui.control_center.header")
local buttons = require("ui.control_center.buttons")
local vol_slider = require("ui.control_center.sliders.volume")
local brightness_slider = require("ui.control_center.sliders.brightness")
local music = require("ui.control_center.music")
---------------------------
--Main window--------------
---------------------------
local control = awful.popup {
	-- screen = s,
	widget = wibox.container.background,
	ontop = true,
	bg = "#00000000",
	visible = false,
	placement = function(c)
		awful.placement.bottom_right(c,
			{ margins = { top = dpi(0), bottom = dpi(55), left = dpi(8), right = dpi(8) } })
	end,
}

control:setup({
	{
		{
			header,
			buttons,
			vol_slider,
			brightness_slider,
			music,
			layout = wibox.layout.fixed.vertical
		},
		bg_blank,
		layout = wibox.layout.stack
	},
	widget = wibox.container.background,
	bg = color.bg_dark,
	shape = helpers.rrect(8),
	border_width = 3,
	border_color = color.bg_normal
})

--Signals
awesome.connect_signal("control::toggle", function()
	control.visible = not control.visible
end)

awesome.connect_signal("control::on", function()
	control.visible = true
end)

awesome.connect_signal("control::off", function()
	control.visible = false
end)
