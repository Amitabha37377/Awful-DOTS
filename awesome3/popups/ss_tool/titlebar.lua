local beautiful = require 'beautiful'
local wibox = require 'wibox'
local dpi = beautiful.xresources.apply_dpi

local color = require 'themes.colors'
local helpers = require 'helpers'

-----------------------
--Buttons--------------
-----------------------
local create_button = function(text, click_color, fg, wgt_shape)
	local btn = wibox.widget {
		helpers.margin(
			helpers.textbox(fg, "Ubuntu nerd font bold 16", text),
			9, 9, 6, 6
		),
		widget = wibox.container.background,
		bg = click_color,
		shape = wgt_shape
	}

	return btn
end

local screenshot = create_button("󰄄 Screenshot", color.blue, color.bg_dark,
	helpers.part_rrect(true, true, true, true, 4))

local screenrecord = create_button("  Screenrecord", color.bg_normal, color.mid_light,
	helpers.part_rrect(false, true, true, false, 4))

local close = helpers.margin(
	helpers.textbox(color.red, "Ubuntu nerd font bold 25", '󰅗'),
	0, 12, 8, 8
)

local left = helpers.margin(
	wibox.widget {
		screenshot,
		layout = wibox.layout.fixed.horizontal
	},
	25, 0, 11, 11
)

---------------------
--MainWidget---------
---------------------
local titlebar = wibox.widget {
	{
		left,
		nil,
		close,
		layout = wibox.layout.align.horizontal
	},
	widget = wibox.container.background,
	bg = color.bg_dim
}

close:connect_signal("button::release", function()
	awesome.emit_signal("ss_tool::close")
end)

return titlebar
