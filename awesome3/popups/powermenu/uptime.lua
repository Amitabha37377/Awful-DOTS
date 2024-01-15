local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local dpi = beautiful.xresources.apply_dpi

local helpers = require('helpers')
local color = require('themes.colors')
local user = require("user")

local uptime = wibox.widget {
	widget = wibox.widget.textbox,
	markup = helpers.mtext(color.purple, "Ubuntu nerd font bold 20", "Uptime : ") ..
			helpers.mtext(color.lightblue, "Ubuntu nerd font bold 20", "2days 14hrs 16mins"),
	valign = 'center',
	halign = 'center',
}

awful.spawn.easy_async_with_shell('uptime -p', function(stdout)
	uptime.markup = helpers.mtext(color.lightblue, "Ubuntu nerd font bold 20", tostring(stdout))
end)

local footer = wibox.widget {
	{
		orientation = 'horizontal',
		forced_height = dpi(1.5),
		forced_width = dpi(1.5),
		span_ratio = 0.75,
		widget = wibox.widget.separator,
		color = color.fg_normal,
		border_color = color.fg_normal,
		opacity = 0.6
	},

	helpers.margin(uptime, 10, 10, 25, 35),
	layout = wibox.layout.fixed.vertical
}

return footer
