local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi
local helpers = require('helpers')
local color = require("themes.colors")

local bg_blank = wibox.widget.textbox("   ")
bg_blank.forced_height = dpi(300)
bg_blank.forced_width = dpi(480)

---------------------------
--Modules------------------
---------------------------
local header = require("popups.control_center.header")
local buttons = require("popups.control_center.buttons")
local vol_slider = require("popups.control_center.sliders.volume")
local brightness_slider = require("popups.control_center.sliders.brightness")
local music = require("popups.control_center.music")
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
		awful.placement.top_right(c,
			{ margins = { top = dpi(45), bottom = dpi(0), left = dpi(8), right = dpi(8) } })
	end,
}

control:setup({
	{
		{
			header,
			vol_slider,
			brightness_slider,
			buttons,
			music,
			layout = wibox.layout.fixed.vertical
		},
		bg_blank,
		layout = wibox.layout.stack
	},
	widget = wibox.container.background,
	bg = color.bg_dim,
	shape = helpers.rrect(8),
	border_width = 3,
	border_color = color.bg_dim
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
