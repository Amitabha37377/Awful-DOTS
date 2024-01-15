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
local calendar = require('layout.panel.calendar')
local todo = require('layout.panel.todo')

local panel = wibox.widget {
	control,
	calendar,
	todo,
	{
		nil,
		nil,
		tabs,
		layout = wibox.layout.align.vertical,
	},
	layout = wibox.layout.stack,
}

awesome.connect_signal('panel::calendar', function()
	control.visible = false
	todo.visible = false
	calendar.visible = true
end)

awesome.connect_signal('panel::control', function()
	control.visible = true
	todo.visible = false
	calendar.visible = false
end)

awesome.connect_signal('panel::todo', function()
	control.visible = false
	todo.visible = true
	calendar.visible = false
end)

awesome.connect_signal('panel::settings', function()
	control.visible = false
	todo.visible = false
	calendar.visible = false
end)



-- calendar.visible = false

return panel
