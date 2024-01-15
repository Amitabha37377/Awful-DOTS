local awful     = require('awful')
local gears     = require('gears')
local wibox     = require('wibox')
local beautiful = require('beautiful')

local dpi       = beautiful.xresources.apply_dpi
local helpers   = require('helpers')
local color     = require("themes.colors")

local modkey    = "Mod4"


local create_taglist = function(s)
	local taglist_buttons = gears.table.join(
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



	local update_tag = function(self, c3, _)
		if c3.selected then
			self:get_children_by_id('tags')[1].forced_height = dpi(45)
			self:get_children_by_id('tags')[1].bg = color.lightblue
		elseif #c3:clients() == 0 then
			self:get_children_by_id('tags')[1].forced_height = dpi(20)
			self:get_children_by_id('tags')[1].bg = color.mid_dark
		else
			if c3.urgent then
				self:get_children_by_id('tags')[1].forced_height = dpi(35)
				self:get_children_by_id('tags')[1].bg            = color.orange
			else
				self:get_children_by_id('tags')[1].forced_height = dpi(35)
				self:get_children_by_id('tags')[1].bg            = color.fg_normal
			end
		end
	end

	local taglist = awful.widget.taglist {
		screen = s,
		filter = awful.widget.taglist.filter.all,
		layout = { layout = wibox.layout.fixed.vertical, spacing = dpi(100), shape = gears.shape.circle },
		style = { font = "Ubuntu nerd font 16 bold" },
		widget_template = {
			id = 'tags',
			widget = wibox.container.background,
			bg = color.fg_normal,
			forced_height = dpi(20),
			forced_width = dpi(10),
			shape = gears.shape.rounded_bar,
			create_callback = function(self, c3, _)
				update_tag(self, c3, _)
			end,
			update_callback = function(self, c3, _)
				update_tag(self, c3, _)
			end,
		},

		buttons = taglist_buttons
	}

	local the_taglist = helpers.margin(wibox.widget
		{
			{
				{
					nil,
					layout = wibox.layout.align.horizontal,
					taglist,
					nil,
					expand = 'none'
				},
				widget = wibox.container.margin,
				margins = dpi(15)
			},
			widget = wibox.container.background,
			bg = color.bg_dim,
			shape = helpers.rrect(dpi(4))
		},
		5, 5, 5, 5)

	the_taglist.forced_width = dpi(50)

	return the_taglist
end

return create_taglist
