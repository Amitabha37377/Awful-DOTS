--Standard Modules
local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--color and icons
local color = require("layout.dock.color")
local user = require("popups.user_profile")
local icon_path = user.icon_theme_path


-- tasklist buttons
local deco = {
	-- wallpaper = require("deco.wallpaper"),
	taglist = require("deco.taglist"),
	tasklist = require("deco.tasklist"),
}

local taglist_buttons = deco.taglist()
local tasklist_buttons = deco.tasklist()


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
		bg = "#151520",
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 8)
		end,
	},
	bg = "#00000000",
	ontop = true,
	placement = function(c)
		return awful.placement.bottom(c, { margins = { bottom = dpi(75), left = dpi(800) } })
	end,
	visible = false,
})

--Button to open the popup box
local button = wibox.widget {
	{
		{
			widget = wibox.widget.imagebox,
			image = os.getenv("HOME") .. "/.icons/Papirus/48x48/apps/appimagekit-dockstation.svg",
			resize = true,
			opacity = 1,
		},
		left   = dpi(1.1),
		right  = dpi(1.1),
		top    = dpi(1.1),
		bottom = dpi(1.1),
		widget = wibox.container.margin
	},
	bg = color.background_dark,
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
	forced_height = dpi(48),
	forced_width = dpi(48),
}

--Hover highlight effects
button:connect_signal("mouse::enter", function()
	if not popup.visible then
		button.bg = color.background_lighter
	end
end)

button:connect_signal("mouse::leave", function()
	if not popup.visible then
		button.bg = color.background_dark
	end
end)

button:connect_signal("button::press", function()
	button.bg = color.background_morelight
end)

button:connect_signal("button::release", function()
	if not popup.visible then
		button.bg = color.background_lighter
	end
end)

--Open popup box on click
button:connect_signal("button::release", function()
	popup.visible = not popup.visible
	if popup.visible then
		button.bg = color.background_morelight
	end
end)

return button
