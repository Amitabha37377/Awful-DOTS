local awful = require 'awful'
local beautiful = require 'beautiful'
local gears = require 'gears'
local wibox = require 'wibox'
local dpi = beautiful.xresources.apply_dpi
local naughty = require 'naughty'

local color = require 'themes.colors'
local helpers = require 'helpers'

---------------------
--timer--------------
---------------------
local delay_time = 3
local function timer_value(num)
	if (num > 0) then
		Value = num;
	else
		Value = 0;
	end
	return Value
end

local increase = helpers.textbox(color.yellow, "Ubuntu nerd font bold 15", "    ")
local decrease = helpers.textbox(color.red, "Ubuntu nerd font bold 15", "    ")
local timer = helpers.textbox(color.blue, "Ubuntu nerd font bold 15", "󱎫 " .. timer_value(delay_time))
local delay_text = helpers.textbox(color.fg_normal, "ubuntu nerd font 15", "Delay in seconds")

increase:connect_signal("button::press", function()
	delay_time = timer_value(delay_time) + 1
	timer.markup = helpers.mtext(color.blue, "Ubuntu nerd font bold 15", "󱎫 " .. timer_value(delay_time))
end)

decrease:connect_signal("button::press", function()
	delay_time = timer_value(delay_time) - 1
	timer.markup = helpers.mtext(color.blue, "Ubuntu nerd font bold 15", "󱎫 " .. timer_value(delay_time))
end)

local vertical_separator = wibox.widget {
	orientation = 'vertical',
	forced_height = dpi(1.5),
	forced_width = dpi(1.5),
	span_ratio = 0.75,
	widget = wibox.widget.separator,
	color = "#a9b1d6",
	border_color = "#a9b1d6",
	opacity = 0.75
}

local delay_control = wibox.widget {
	{
		{
			increase,
			vertical_separator,
			decrease,
			layout = wibox.layout.fixed.horizontal
		},
		widget = wibox.container.margin,
		left = dpi(4),
		right = dpi(4)
	},
	widget = wibox.container.background,
	bg = color.bg_normal,
	shape = helpers.rrect(5)
}

local delay = wibox.widget {
	{
		helpers.margin(delay_text, 15, 0, 12, 12),
		nil,
		{
			helpers.margin(timer, 10, 10, 12, 12),
			helpers.margin(delay_control, 0, 15, 7, 7),
			layout = wibox.layout.fixed.horizontal
		},
		layout = wibox.layout.align.horizontal
	},
	widget = wibox.container.background,
	bg = color.bg_normal,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 5)
	end,

}

---------------------
--cursor_toggle------
---------------------
local show_cursor = true

local text = helpers.textbox(color.fg_normal, "Ubuntu nerd font 15", "Show cursor")
local toggle = helpers.textbox(color.lightblue, "Ubuntu nerd font bold 20", "   ")

local toggle_cursor = wibox.widget {
	{
		helpers.margin(text, 15, 10, 12, 12),
		nil,
		helpers.margin(toggle, 10, 15, 8, 8),
		layout = wibox.layout.align.horizontal
	},
	widget = wibox.container.background,
	bg = color.bg_normal,
	shape = helpers.rrect(5)
}

toggle:connect_signal("button::release", function()
	show_cursor = not show_cursor
	if show_cursor then
		toggle.markup = helpers.mtext(color.lightblue, "Ubuntu nerd font bold 20", "   ")
	else
		toggle.markup = helpers.mtext(color.lightblue, "Ubuntu nerd font bold 20", "   ")
	end
end)

---------------------
--Modules------------
---------------------
local button = require 'popups.ss_tool.screenshot.buttons'

local ss = wibox.widget { {
	{
		helpers.margin(button.fullscreen, 10, 10, 20, 12),
		helpers.margin(button.select, 10, 10, 20, 12),
		helpers.margin(button.timer, 10, 10, 20, 12),
		layout = wibox.layout.fixed.horizontal
	},
	widget = wibox.container.place
},
	helpers.margin(delay, 25, 25, 10, 0),
	helpers.margin(toggle_cursor, 25, 25, 10, 0),
	layout = wibox.layout.fixed.vertical
}

---------------------------------
--Functionality------------------
---------------------------------
local ss_index = tonumber(io.popen("cat ~/.config/awesome/popups/ss_tool/ss_index.txt"):read("*all"))

local create_actions = function(action_name, task)
	local action = naughty.action {
		name = action_name,
		icon_only = false
	}
	action:connect_signal(
		'invoked',
		function()
			awful.spawn.with_shell(task, false)
		end
	)
	return action
end

local function ss_normal()
	awesome.emit_signal("ss_tool::close")
	awful.spawn.easy_async_with_shell('sleep 0.3 && scrot ~/Pictures/' .. ss_index .. '.png',
		function()
			naughty.notify
			(
				{
					title = helpers.mtext(color.fg_normal, "Ubuntu nerd font bold 13", '  Screenshot Tool'),
					text = helpers.mtext(color.fg_normal, "Ubuntu nerd font 13",
						"Screenshot captured! (" .. ss_index .. ".png)"),
					timeout = 5,
					icon = os.getenv("HOME") .. "/Pictures/" .. ss_index .. ".png",
					actions = {
						create_actions("Open", 'feh Pictures/' .. (ss_index) .. '.png --scale-down'),
						create_actions("Pictures", "thunar ~/Pictures"),
						create_actions("Delete", 'feh Pictures/' .. (ss_index) .. '.png --scale-down'),
					}
				}
			)
			ss_index = ss_index + 1
			awful.spawn.with_shell('echo ' .. ss_index + 1 .. ' > ~/.config/awesome/popups/ss_tool/ss_index.txt')
		end)
end

local function ss_timed()
	awesome.emit_signal("ss_tool::close")
	awful.spawn.easy_async_with_shell(
		'sleep 0.3 && scrot -d ' .. timer_value(delay_time) .. ' ~/Pictures/' .. ss_index .. '.png',
		function()
			naughty.notify
			(
				{
					title = helpers.mtext(color.fg_normal, "Ubuntu nerd font bold 13", '  Screenshot Tool'),
					text = helpers.mtext(color.fg_normal, "Ubuntu nerd font 13",
						"Screenshot captured! (" .. ss_index .. ".png)"),
					timeout = 5,
					icon = os.getenv("HOME") .. "/Pictures/" .. ss_index .. ".png",
					actions = {
						create_actions("Open", 'feh Pictures/' .. (ss_index) .. '.png --scale-down'),
						create_actions("Pictures", "thunar ~/Pictures"),
						create_actions("Delete", 'feh Pictures/' .. (ss_index) .. '.png --scale-down'),
					}
				}
			)
			ss_index = ss_index + 1
			awful.spawn.with_shell('echo ' .. ss_index + 1 .. ' > ~/.config/awesome/popups/ss_tool/ss_index.txt')
		end)
end

local function ss_selection()
	awesome.emit_signal("ss_tool::close")
	awful.spawn.easy_async_with_shell(
		'sleep 0.3 && scrot -s ' .. '~/Pictures/' .. ss_index .. '.png',
		function()
			naughty.notify
			(
				{
					title = helpers.mtext(color.fg_normal, "Ubuntu nerd font bold 13", '  Screenshot Tool'),
					text = helpers.mtext(color.fg_normal, "Ubuntu nerd font 13",
						"Screenshot captured! (" .. ss_index .. ".png)"),
					timeout = 5,
					icon = os.getenv("HOME") .. "/Pictures/" .. ss_index .. ".png",
					actions = {
						create_actions("Open", 'feh Pictures/' .. (ss_index) .. '.png --scale-down'),
						create_actions("Pictures", "thunar ~/Pictures"),
						create_actions("Delete", 'rm Pictures/' .. (ss_index) .. '.png'),
					}
				}
			)
			ss_index = ss_index + 1
			awful.spawn.with_shell('echo ' .. ss_index + 1 .. ' > ~/.config/awesome/popups/ss_tool/ss_index.txt')
		end)
end


button.fullscreen:connect_signal("button::release", function()
	ss_normal()
end)

button.timer:connect_signal("button::release", function()
	ss_timed()
end)

button.select:connect_signal("button::release", function()
	ss_selection()
end)

return ss
