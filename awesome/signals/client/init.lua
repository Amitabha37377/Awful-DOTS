local awful = require 'awful'
require 'awful.autofocus'
local wibox = require 'wibox'

local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local color = require('themes.colors')


client.connect_signal('mouse::enter', function(c)
	c:activate { context = 'mouse_enter', raise = false }
end)

client.connect_signal('request::titlebars', function(c)
	-- buttons for the titlebar
	local buttons = {
		awful.button {
			modifiers = {},
			button    = 1,
			on_press  = function()
				c:activate { context = 'titlebar', action = 'mouse_move' }
			end
		},
		awful.button {
			modifiers = {},
			button    = 3,
			on_press  = function()
				c:activate { context = 'titlebar', action = 'mouse_resize' }
			end
		},
	}

	awful.titlebar(c, {
		size = dpi(38)
	}).widget = {
		-- left
		{
			{
				-- awful.titlebar.widget.floatingbutton(c),
				awful.titlebar.widget.ontopbutton(c),
				-- awful.titlebar.widget.iconwidget(c),
				layout = wibox.layout.fixed.horizontal,
			},
			widget = wibox.container.margin,
			margins = dpi(4),
			-- left = dpi(12),
		},
		-- middle
		{
			-- title
			{
				align = 'center',
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout  = wibox.layout.flex.horizontal,
		},
		-- right
		{
			{
				-- awful.titlebar.widget.floatingbutton(c),
				awful.titlebar.widget.minimizebutton(c),
				awful.titlebar.widget.maximizedbutton(c),
				-- awful.titlebar.widget.stickybutton(c),
				-- awful.titlebar.widget.ontopbutton(c),
				awful.titlebar.widget.closebutton(c),
				layout = wibox.layout.fixed.horizontal()
			},
			widget = wibox.container.margin,
			top = dpi(4),
			right = dpi(8),
			bottom = dpi(4)
		},
		layout = wibox.layout.align.horizontal,
	}
end)

----------------------
--Borders-------------
----------------------
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
	c.border_color = color.bg_dim
end)
client.connect_signal("unfocus", function(c)
	c.border_color = color.bg_dim
end)
-- }}}
client.connect_signal("focus", function(c)
	c.border_width = 2
end)
client.connect_signal("unfocus", function(c)
	c.border_width = 2
end)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	if not awesome.startup then
		awful.client.setslave(c)
	end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- client.connect_signal("property::floating", function(c)
-- 	if c.floating then
-- 		c.ontop = true
-- 	else
-- 		c.ontop = false
-- 	end
-- end)
