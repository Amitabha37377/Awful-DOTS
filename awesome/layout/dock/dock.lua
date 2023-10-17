local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Color
local color = require("layout.dock.color")

local Item1 = require("layout.dock.widgets.launcher")

local apps = require("layout.dock.widgets.apps")
local Item2 = apps.firefox
local Item3 = apps.vscode
local Item4 = apps.term
local Item5 = apps.gimp
local Item6 = apps.telegram
local Item7 = apps.discord
local Item8 = apps.vokoscreenNG
local Item9 = apps.unity
local Item10 = apps.only_office
local Item11 = apps.keepassxc

local directories = require("layout.dock.widgets.directories")
local home = directories.home
local downloads = directories.downloads
local documents = directories.documents
local config = directories.config

local task_popup = require("layout.dock.widgets.tasklist")
local layoutbox = require("layout.dock.widgets.layoutbox")
local color_picker = apps.gpick


--Separator line
local vertical_separator = wibox.widget {
	orientation = 'vertical',
	forced_height = dpi(1.5),
	forced_width = dpi(1.5),
	span_ratio = 0.55,
	widget = wibox.widget.separator,
	color = "#a9b1d6",
	border_color = "#a9b1d6",
	opacity = 0.55
}

--Separator
local Separator = wibox.widget.textbox("   ")
Separator.forced_height = dpi(60)

local Separator2 = wibox.widget.textbox(" ")

--Main dock
local dock = awful.popup {
	screen = s,
	widget = wibox.container.background,
	ontop = false,
	bg = "#00000000",
	visible = true,
	maximum_height = dpi(60),
	placement = function(c)
		awful.placement.bottom(c,
			{ margins = { top = dpi(8), bottom = dpi(5), left = 0, right = 0 } })
	end,
	type = "dock"
}

dock:struts {
	bottom = dpi(64)
}

dock:setup {
	{
		Separator2,
		Separator2,
		Separator2,
		Separator,
		{
			Item1,
			layout = wibox.container.place
		},
		Separator,
		vertical_separator,
		Separator,
		{
			Item2,
			layout = wibox.container.place
		},
		Separator,
		{
			Item3,
			layout = wibox.container.place
		},
		Separator,
		{
			Item4,
			layout = wibox.container.place
		},
		Separator,
		{
			Item5,
			layout = wibox.container.place
		},
		Separator,
		{
			Item6,
			layout = wibox.container.place
		},
		Separator,
		{
			Item7,
			layout = wibox.container.place
		},
		Separator,
		{
			Item8,
			layout = wibox.container.place
		},
		Separator,
		{
			Item9,
			layout = wibox.container.place
		},
		Separator,
		{
			Item10,
			layout = wibox.container.place
		},
		Separator,

		{
			Item11,
			layout = wibox.container.place
		},

		Separator,
		vertical_separator,
		Separator,

		{
			home,
			layout = wibox.container.place
		},
		Separator,

		{
			downloads,
			layout = wibox.container.place
		},
		Separator,
		{
			documents,
			layout = wibox.container.place
		},

		Separator,
		{
			config,
			layout = wibox.container.place,
		},
		Separator,
		vertical_separator,
		Separator,

		{
			color_picker,
			layout = wibox.container.place,
		},
		Separator,


		{
			task_popup,
			layout = wibox.container.place,
		},
		Separator,

		{
			layoutbox,
			layout = wibox.container.place,
		},
		Separator,
		Separator2,

		layout = wibox.layout.fixed.horizontal,
	},
	widget = wibox.container.background,
	-- bg = color.background_dark,
	bg = color.background_dark,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 15)
	end,
}

return dock
