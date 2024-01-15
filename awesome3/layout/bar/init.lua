local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local dpi = beautiful.xresources.apply_dpi

local helpers = require('helpers')
local color = require('themes.colors')
local rubato = require('modules.rubato')

local sep = wibox.widget.textbox(" ")
sep.forced_width = dpi(50)
sep.forced_height = awful.screen.focused().workarea.height

local sep2 = wibox.widget.textbox(" ")
sep2.forced_width = dpi(450)
sep2.forced_height = awful.screen.focused().workarea.height

-------------------------
--Bar Modules------------
-------------------------
local launcher = require 'layout.bar.modules.launcher'
local clock = require 'layout.bar.modules.clock'
local buttons = require 'layout.bar.modules.buttons'
local systray = require 'layout.bar.modules.systray'
local battery = require 'layout.bar.modules.battery'

local battery_widget = wibox.widget {
	{
		helpers.margin(battery({
				show_current_level = true,
				arc_thickness = 3,
				size = 30,
				font = "Ubuntu nerd font bold 10",
				margins = 55,
				timeout = 10,
				main_color = color.lightblue
			}),
			5, 5, 5, 5),
		widget = wibox.container.background,
		bg = color.bg_dim,
		shape = helpers.rrect(4)
	},
	widget = wibox.container.margin,
	margins = dpi(5),
	forced_width = dpi(50)
}

-------------------------
--Panel Modules----------
-------------------------
local panel = require 'layout.panel'



--------------------------------
--Panels------------------------
--------------------------------
awful.screen.connect_for_each_screen(function(s)
	--Taglist---------
	local taglist = require("layout.bar.modules.taglist")(s)

	--------------------
	--Bar---------------
	--------------------
	s.bar = awful.wibar {
		width = dpi(50),
		screen = s,
		position = "left",
		height = awful.screen.focused().workarea.height,
		bg = "#000000",
		widget = wibox.container.background,
		x = dpi(00),
		shape = helpers.rrect(0)
	}

	s.bar:setup({
		{
			{
				{ launcher, clock,   layout = wibox.layout.fixed.vertical },
				nil,
				{ systray,  buttons, battery_widget,                      layout = wibox.layout.fixed.vertical },
				layout = wibox.layout.align.vertical
			},
			{
				{
					taglist,
					layout = wibox.layout.fixed.vertical
				},
				widget = wibox.container.place
			},
			sep,
			layout = wibox.layout.stack
		},
		widget = wibox.container.background,
		bg = color.bg_dark,
	}
	)

	-- s.bar:struts({ left = 50 })

	--------------------------
	--Side panel--------------
	--------------------------
	s.bar2 = awful.popup {
		width = dpi(450),
		screen = s,
		height = awful.screen.focused().workarea.height,
		ontop = true,
		bg = "#000000",
		widget = wibox.container.background,
		x = dpi(-450),
		shape = helpers.rrect(0),
		visible = true
	}

	s.bar2:setup {
		{
			panel,
			sep2,
			layout = wibox.layout.stack
		},
		widget = wibox.container.background,
		bg = color.bg_dim
	}

	-----------------------
	--Toggle sidebar-------
	-----------------------
	awesome.connect_signal("slide::bar", function()
		s.bar.ontop = true
		if s.bar.x == 0 then
			local timed = rubato.timed {
				duration = 1 / 6,
				intro = 1 / 13,
				override_dt = true,
				subscribed = function(pos)
					s.bar.x = pos
				end
			}
			timed.target = 450
		end
	end)

	awesome.connect_signal("fold::bar", function()
		if s.bar2.x ~= 0 then
			local timed = rubato.timed {
				duration = 1 / 4,
				intro = 1 / 9,
				override_dt = true,
				subscribed = function(pos)
					s.bar.x = pos + 450
				end
			}
			timed.target = -450
			awful.spawn.easy_async('sleep 0.4', function()
				s.bar.ontop = false
			end)
		end
	end)



	local open = false
	awesome.connect_signal("open::window", function()
		open = not open
		if open then
			s.bar.ontop = true
			local timed = rubato.timed {
				duration = 1 / 5,
				intro = 1 / 11,
				override_dt = true,
				subscribed = function(pos)
					s.bar.x = pos
					s.bar2.x = pos - 450
				end
			}
			timed.target = 450
		else
			local timed = rubato.timed {
				duration = 1 / 4,
				intro = 1 / 9,
				override_dt = true,
				subscribed = function(pos)
					s.bar.x = pos + 450
					s.bar2.x = pos
				end
			}
			timed.target = -450
			awful.spawn.easy_async("sleep 0.25", function()
				s.bar.ontop = false
			end)
		end
	end)
end)

--Slide bar signal
