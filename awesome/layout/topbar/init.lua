local awful = require 'awful'
local beautiful = require 'beautiful'
local wibox = require 'wibox'
local dpi = beautiful.xresources.apply_dpi

local helpers = require 'helpers'
local color = require 'themes.colors'
local user = require 'user'

local sep = wibox.widget.textbox("   ")

--Modules
local textclock = require 'layout.topbar.middle.textclock'
local logo = require 'layout.topbar.left.logo'
local fancy_taglist = require 'layout.topbar.left.fancy_taglist'
local batteryarc_widget = require 'layout.topbar.right.battery_arc'
local buttons = require 'layout.topbar.right.buttons'
local systray = require 'layout.topbar.right.systray'


local topbar = awful.wibar({
	position = "top",
	margins = user.topbar_floating and { top = dpi(7), left = dpi(8), right = dpi(8), bottom = 0 } or 0,
	-- margins = { top = dpi(0), left = dpi(0), right = dpi(0), bottom = 0 },
	screen = s,
	height = dpi(35),
	opacity = 1,
	bg = "#00000000",
})

topbar:setup({
	{
		layout = wibox.layout.stack,
		expand = "none",
		{
			{
				logo,
				fancy_taglist,
				layout = wibox.layout.fixed.horizontal
			},
			nil,
			{
				systray,
				buttons,
				batteryarc_widget({
					show_current_level = true,
					arc_thickness = 3,
					size = 26,
					font = "CaskaydiaCove Nerd Font 10",
					margins = 55,
					timeout = 10,
				}),
				sep,
				layout = wibox.layout.fixed.horizontal
			},
			layout = wibox.layout.align.horizontal
		},
		{
			textclock,
			widget = wibox.container.place
		},
	},
	widget = wibox.widget.background,
	bg = color.bg_dim,
	shape = user.topbar_floating and helpers.rrect(7) or helpers.rrect(0)
})
