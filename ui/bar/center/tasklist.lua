local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
local gears = require('gears')

local dpi = beautiful.xresources.apply_dpi
local helpers = require('helpers')
local color = require("themes.colors")
local user = require('user')



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

--Tasklist Popup box
local popup = awful.popup({
	widget = {
		{
			awful.widget.tasklist({
				screen = screen[1],
				filter = awful.widget.tasklist.filter.allscreen,
				buttons = tasklist_buttons,
				margins = {
					top = dpi(20),
					bottom = dpi(20),
					left = dpi(20),
					right = dpi(20),
				},
				style = {
					shape = gears.shape.rounded_rect,
				},
				layout = {
					margins = dpi(5),
					spacing = dpi(15),
					forced_num_rows = 2,
					layout = wibox.layout.grid.horizontal,
				},
				widget_template = {
					{
						{
							id = "clienticon",
							widget = awful.widget.clienticon,
							resize = true,
						},
						margins = dpi(10),
						widget = wibox.container.margin,
					},
					id = "background_role",
					forced_width = dpi(68),
					forced_height = dpi(68),
					widget = wibox.container.background,
					create_callback = function(self, c, index, objects)
						self:get_children_by_id("clienticon")[1].client = c
					end,
				},
			}),
			widget = wibox.container.margin,
			margins = dpi(15)
		},
		widget = wibox.container.background,
		bg = color.bg_dark,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 8)
		end,
	},
	bg = "#00000000",
	ontop = true,
	placement = function(c)
		return awful.placement.bottom(c, { margins = { bottom = dpi(55), left = dpi(300) } })
	end,
	visible = false,
})

local button = wibox.widget {
	{
		{
			image = user.icon_path .. 'dock' .. '.svg',
			resize = true,
			widget = wibox.widget.imagebox,
		},
		widget = wibox.container.margin,
		margins = dpi(3)
	},
	widget = wibox.container.background,
	bg = color.bg_dark,
	shape = helpers.rrect(dpi(4)),
	id = 'background'
}



helpers.add_hover_effect(button, color.bg_normal, color.bg_light, color.bg_dark)

--Open popup box on click
button:connect_signal("button::release", function()
	popup.visible = not popup.visible
	if popup.visible then
		button.bg = color.background_morelight
	end
end)

return button
