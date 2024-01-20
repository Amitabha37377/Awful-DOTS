local awful            = require 'awful'
local wibox            = require 'wibox'
local beautiful        = require 'beautiful'
local gears            = require 'gears'
local dpi              = beautiful.xresources.apply_dpi

local modkey           = "Mod4"

local color            = require 'themes.colors'

-- Taglist Buttons-------
-------------------------

local taglist_buttons  = gears.table.join(
	awful.button({}, 1,
		function(t) t:view_only() end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then client.focus:move_to_tag(t) end
	end), awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then client.focus:toggle_tag(t) end
	end), awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end), awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end))

--Tasklist Buttons-------
-------------------------

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			awful.tag.viewonly(c.first_tag) -- This line switches to the client's workspace
			c:emit_signal(
				"request::activate",
				"tasklist",
				{ raise = true }
			)
		end
	end),
	awful.button({}, 3, function(c)
		-- awful.menu.client_list({ theme = { width = 250 } })
		c:kill()
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

awful.screen.connect_for_each_screen(function(s)
	local fancy_taglist = require("modules.fancy_taglist")
	Mytaglist = fancy_taglist.new({
		screen   = s,
		taglist  = { buttons = taglist_buttons },
		tasklist = { buttons = tasklist_buttons },
		filter   = awful.widget.taglist.filter.all,
		style    = {
			shape = gears.shape.rounded_rect
		},
	})
end)

local fancy_taglist = wibox.widget {
	{
		Mytaglist,
		widget = wibox.container.background,
		shape  = gears.shape.rounded_rect,
		bg     = color.bg_normal
	},
	left   = dpi(3),
	right  = dpi(3),
	top    = dpi(3),
	bottom = dpi(3),
	widget = wibox.container.margin
}

return fancy_taglist
