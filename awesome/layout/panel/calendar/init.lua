local wibox = require('wibox')
local beautiful = require('beautiful')

local clock = require('layout.panel.calendar.clock')
local calendar = require('layout.panel.calendar.calendar')
local weather = require('layout.panel.calendar.weather')
local sys = require('layout.panel.calendar.sys')

local cal = wibox.widget {
	clock,
	calendar,
	weather,
	sys,
	layout = wibox.layout.fixed.vertical,
	visible = false
}

return cal
