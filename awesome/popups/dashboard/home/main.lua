--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Custom Modules
local color = require("popups.color")

local header = require("popups.dashboard.home.headers")

--Home Widgets
local profile = require("popups.dashboard.home.widgets.profile")
local calender = require("popups.dashboard.home.widgets.calendar")
local weather = require("popups.dashboard.home.widgets.weather")
local launch = require("popups.dashboard.home.widgets.quick_launch")
local exit = require("popups.dashboard.home.widgets.exit")

--Todo Widgets
local timer = require("popups.dashboard.home.todo_widgets.stopwatch")
local todo = require("popups.dashboard.home.todo_widgets.todo")

--Separator/Background
local Separator = wibox.widget.textbox("    ")
Separator.forced_height = 950
Separator.forced_width = 440

--Sidebar
local sidebar = require("popups.dashboard.home.sidebar")

--Main Wibox
local dashboard_home = awful.popup {
	screen = s,
	widget = wibox.container.background,
	ontop = true,
	bg = "#00000000",
	visible = false,
	forced_width = 450,
	maximum_height = 950,
	placement = function(c)
		awful.placement.top_left(c,
			{ margins = { top = dpi(43), bottom = dpi(8), left = dpi(8), right = dpi(8) } })
	end,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 0)
	end,
	opacity = 1
}

local home = wibox.widget {
	header.home,
	profile,
	calender,
	weather,
	launch,
	exit,
	layout = wibox.layout.fixed.vertical,
}

local todo = wibox.widget {
	header.todo,
	timer,
	todo,
	layout = wibox.layout.fixed.vertical,
	visible = false
}

local sys_monitor = wibox.widget {
	header.sys_monitor,
	layout = wibox.layout.fixed.vertical,
	visible = false
}

local settings = wibox.widget {
	header.settings,
	layout = wibox.layout.fixed.vertical,
	visible = false
}


dashboard_home:setup {
	{
		{
			home,
			todo,
			settings,
			sys_monitor,
			Separator,
			layout = wibox.layout.stack
		},
		sidebar,
		layout = wibox.layout.fixed.horizontal
	},
	widget = wibox.container.background,
	bg = color.background_dark,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 10)
	end,
}

--Signals
awesome.connect_signal("dashboard::home", function()
	home.visible = true
	todo.visible = false
	sys_monitor.visible = false
	settings.visible = false
end
)

awesome.connect_signal("dashboard::todo", function()
	home.visible = false
	todo.visible = true
	sys_monitor.visible = false
	settings.visible = false
end)

awesome.connect_signal("dashboard::settings", function()
	home.visible = false
	todo.visible = false
	sys_monitor.visible = false
	settings.visible = true
end)

awesome.connect_signal("dashboard::sys_monitor", function()
	home.visible = false
	todo.visible = false
	sys_monitor.visible = true
	settings.visible = false
end)

return dashboard_home
