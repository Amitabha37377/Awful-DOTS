local wibox = require('wibox')

local header = require('layout.panel.todo.header')
local stopwatch = require('layout.panel.todo.stopwatch')
local todo = require('layout.panel.todo.todo')

local todo = wibox.widget {
	header,
	stopwatch,
	todo,
	layout = wibox.layout.fixed.vertical,
	visible = false
}

return todo
