local wibox = require 'wibox'
local color = require 'themes.colors'
local helpers = require 'helpers'
local font = require 'user'.font

local calendar_widget = require("layout.topbar.middle.calendar")

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

--Textclock
local mytextclock = wibox.widget.textclock(
	helpers.mtext(color.fg_normal, font .. 'bold 13', '%a %b %d, %H:%M')
)

mytextclock:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		cw.toggle()
	end
end)




return mytextclock
