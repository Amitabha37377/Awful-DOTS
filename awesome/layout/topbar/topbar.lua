-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Custom Local Library: Common Functional Decoration
local deco = {
	-- wallpaper = require("deco.wallpaper"),
	taglist = require("deco.taglist"),
	tasklist = require("deco.tasklist"),
}

local taglist_buttons = deco.taglist()
local tasklist_buttons = deco.tasklist()
local color = require("layout.topbar.colors")
local _M = {}

--Spacer
local separator = wibox.widget.textbox("     ")

local calendar_widget = require("deco.calendar")
local batteryarc_widget = require("deco.batteryarc")


---------------------------
--Widgets------------------
---------------------------

--textclock widget
mytextclock = wibox.widget.textclock(
	'<span color="' .. color.white .. '" font="Ubuntu Nerd Font Bold 13"> %a %b %d, %H:%M </span>', 10)


--calendar-widget
local cw = calendar_widget({
	theme = "nord",
	placement = "top_center",
	start_sunday = true,
	radius = 8,
	previous_month_button = 1,
	padding = 5,
	next_month_button = 3,
})
mytextclock:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		cw.toggle()
	end
end)


--Fancy taglist widget
awful.screen.connect_for_each_screen(function(s)
	local fancy_taglist = require("fancy_taglist")
	mytaglist = fancy_taglist.new({
		screen   = s,
		taglist  = { buttons = taglist_buttons },
		tasklist = { buttons = tasklist_buttons },
		filter   = awful.widget.taglist.filter.all,
		style    = {
			shape = gears.shape.rounded_rect
		},
	})
end)

--Taglist widget
local fancy_taglist = wibox.widget {
	{
		mytaglist,
		widget = wibox.container.background,
		shape  = gears.shape.rounded_rect,
		bg     = color.background_lighter
	},
	left   = dpi(3),
	right  = dpi(3),
	top    = dpi(3),
	bottom = dpi(3),
	widget = wibox.container.margin

}

local awesome_logo = require("layout.topbar.awesome_logo")
local top_left = require("layout.topbar.top_left")
local systray = require("layout.topbar.systray")

-------------------------------------------
-- the wibar
-------------------------------------------

local mywibox =
	awful.wibar({
		position = "top",
		-- margins = { top = dpi(7), left = dpi(8), right = dpi(8), bottom = 0 },
		margins = { top = dpi(0), left = dpi(0), right = dpi(0), bottom = 0 },
		screen = s,
		height = dpi(35),
		opacity = 1,
		fg = color.blueish_white,
		bg = "#00000000",
		-- shape = function(cr, width, height)
		--   -- gears.shape.rounded_rect(cr, width, height, 8)
		--   gears.shape.rounded_rect(cr, width, height, 0)
		-- end,

	})

--Main Wibar
mywibox:setup {
	{
		layout = wibox.layout.stack,
		expand = "none",
		{
			layout = wibox.layout.align.horizontal,
			{
				-- Left widgets
				layout = wibox.layout.fixed.horizontal,
				separator,
				awesome_logo,
				separator,
				fancy_taglist,
				separator,
			},
			nil,
			{
				-- Right widgets
				layout = wibox.layout.fixed.horizontal,
				systray,
				separator,
				top_left,
				separator,
				batteryarc_widget({
					show_current_level = true,
					arc_thickness = 3,
					size = 26,
					font = "CaskaydiaCove Nerd Font 10",
					margins = 55,
					timeout = 10,
				}),

				separator,
			},
		},
		{
			mytextclock,
			valign = "center",
			halign = "center",
			layout = wibox.container.place,
		}
	},
	widget = wibox.container.background,
	bg = color.background_dark,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 0)
		-- gears.shape.rounded_rect(cr, width, height, 0)
	end,

}

return mywibox
