local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi
local helpers = require('helpers')
local color = require("themes.colors")
local user = require('user')

---------------------
--WIdgets------------
---------------------
local launcher = require('ui.bar.modules.launcher')
local clock = require('ui.bar.modules.clock')
local buttons = require('ui.bar.modules.buttons')
local systray = require('ui.bar.modules.systray')
local center = require('ui.bar.center')

local bar_margin, bar_shape

if user.bar_floating then
	bar_margin = { top = dpi(0), bottom = dpi(4), left = dpi(4), right = dpi(4) }
	bar_shape = helpers.rrect(8)
else
	bar_margin = { top = dpi(0), bottom = dpi(0), left = dpi(0), right = dpi(0) }
	bar_shape = helpers.rrect(0)
end

awful.screen.connect_for_each_screen(function(s)
	--
	--Taglist-----------
	--------------------
	local taglist = require("ui.bar.modules.taglist")(s)

	--Bar---------------
	--------------------
	s.bar = awful.wibar({
		position = 'bottom',
		screen   = s,
		visible  = true,
		ontop    = false,
		type     = "dock",
		bg       = "#00000000",
		height   = dpi(48),
		margins  = bar_margin
	})

	s.bar:setup({
		{
			{
				{
					launcher,
					taglist,
					layout = wibox.layout.fixed.horizontal
				},
				nil,
				{
					systray,
					buttons,
					clock,
					layout = wibox.layout.fixed.horizontal
				},
				layout = wibox.layout.align.horizontal
			},
			center,
			layout = wibox.layout.stack
		},
		widget = wibox.container.background,
		bg = color.bg_dark,
		shape = bar_shape
	})
end)
