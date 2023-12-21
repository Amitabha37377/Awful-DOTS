local awful = require 'awful'
local beautiful = require 'beautiful'
local wibox = require 'wibox'
local dpi = beautiful.xresources.apply_dpi

local color = require 'themes.colors'
local helpers = require 'helpers'

local separator = wibox.widget.textbox("  ")
separator.forced_height = dpi(370)
separator.forced_width = dpi(540)

-----------------------
--Modules--------------
-----------------------
local titlebar = require('popups.ss_tool.titlebar')
local screenshot = require('popups.ss_tool.screenshot')
------------------------
--Main window-----------
------------------------
local ss_tool = awful.popup {
	-- screen = s,
	widget = wibox.container.background,
	ontop = true,
	bg = "#00000000",
	visible = false,
	placement = function(c)
		awful.placement.centered(c,
			{ margins = { top = dpi(0), bottom = dpi(0), left = dpi(0), right = dpi(0) } })
	end,
}

ss_tool:setup({
	{
		{
			titlebar,
			screenshot,
			layout = wibox.layout.fixed.vertical
		},
		separator,
		layout = wibox.layout.stack,
	},
	widget = wibox.container.background,
	bg = color.bg_dark,
	border_width = dpi(3),
	border_color = color.bg_dim,
	shape = helpers.rrect(5)
})

-----------------------
--Signals--------------
-----------------------
awesome.connect_signal("ss_tool::toggle", function()
	ss_tool.visible = not ss_tool.visible
end)

awesome.connect_signal("ss_tool::close", function()
	ss_tool.visible = false
end)
