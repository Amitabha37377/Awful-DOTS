local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local dpi = beautiful.xresources.apply_dpi
local gears = require('gears')

local helpers = require('helpers')
local color = require('themes.colors')
local rubato = require('modules.rubato')

local apps = require('layout.dock.apps')
local widgets = require('layout.dock.widgets')
local layoutbox = require('layout.dock.layoutbox')

local h = 1080
local w = 1920

local dock = awful.popup {
	-- screen = s,
	bg = "#00000000",
	widget = wibox.container.background,
	x = dpi((w / 2) - (70 * 6)),
	y = dpi(h + 65),
	shape = helpers.rrect(0),
	ontop = true
}

dock:setup {
	-- wibox.widget.textbox("  "),
	helpers.margin({
		widgets.launcher,
		apps,
		widgets.tasklist,
		widgets.colorpicker,
		layoutbox,
		layout = wibox.layout.fixed.horizontal
	}, 6, 6, 0, 0),
	-- forced_height = dpi(60),
	widget = wibox.container.background,
	bg = color.bg_dim,
	shape = helpers.part_rrect(true, true, false, false, 10)
}

local fakedock = awful.popup {
	width = dpi(50),
	screen = s,
	height = dpi(1080),
	bg = "#00000000",
	widget = wibox.container.background,
	x = dpi((w / 2) - (60 * 6)),
	y = dpi(h - 5),
	shape = helpers.rrect(0),
	ontop = false,
	opacity = 0
}

fakedock:setup {
	wibox.widget.textbox(" "),
	widget = wibox.container.background,
	bg = "#00000000",
	forced_height = dpi(5),
	forced_width = dpi(724)
}

timer = gears.timer {
	timeout = 1,
	autostart = false,
	callback = function()
		local timed = rubato.timed {
			duration = 1 / 4,
			intro = 1 / 9,
			override_dt = true,
			subscribed = function(pos)
				dock.y = dpi(((h + 65) - 139) + pos)
			end
		}
		timed.target = 139
		timer:stop()
	end
}

local keepdock = false
awesome.connect_signal("dock::pausehide", function()
	timer:stop()
	keepdock = true
end)

awesome.connect_signal("dock::hideagain", function()
	keepdock = false
	-- timer:again()
end)


local show_dock = function()
	if dock.y == dpi(h + 65) then
		local timed = rubato.timed {
			duration = 1 / 4,
			intro = 1 / 9,
			override_dt = true,
			subscribed = function(pos)
				dock.y = dpi((h + 65) - pos)
			end
		}
		timed.target = 139
	end
end

fakedock:connect_signal("mouse::enter", function()
	show_dock()
	timer:stop()
end)

dock:connect_signal("mouse::enter", function()
	timer:stop()
end)

dock:connect_signal("mouse::leave", function()
	if not keepdock then
		timer:again()
	end
end)
