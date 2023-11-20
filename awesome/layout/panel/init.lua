local awful = require 'awful'
local beautiful = require 'beautiful'
local wibox = require 'wibox'
local dpi = beautiful.xresources.apply_dpi

local helpers = require 'helpers'
local color = require 'themes.colors'

-----------------------------
--Widgets--------------------
-----------------------------
local tabs = require('layout.panel.tabs')
local control = require('layout.panel.control_center')

local panel = wibox.widget {
	control,
	{
		nil,
		nil,
		tabs,
		layout = wibox.layout.align.vertical,
	},
	layout = wibox.layout.stack,
}

return panel
