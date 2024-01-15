local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local color = require("popups.color")
local icon_path = os.getenv("HOME") .. "/.config/awesome/popups/control_center/assets/"

local powermenu = require("popups.powermenu.main")
local notif_center = require("popups.notif_center.main")

local create_button = function(icon_img, mtop, mbottom, mright, mleft, widget_toggle)
	local button_created = wibox.widget {
		{
			{
				image = icon_path .. icon_img,
				widget = wibox.widget.imagebox,
				resize = true,
				shape = function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, 20)
				end,

			},
			widget = wibox.container.margin,
			top = dpi(mtop),
			bottom = dpi(mbottom),
			right = dpi(mright),
			left = dpi(mleft),
			forced_height = dpi(40)
		},
		widget = wibox.container.background,
		bg = color.background_lighter,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 4)
		end,

	}

	button_created:connect_signal("mouse::enter", function()
		button_created.bg = "#343b58"
	end)

	button_created:connect_signal("mouse::leave", function()
		button_created.bg = color.background_lighter
	end)

	button_created:connect_signal("button::press", function()
		button_created.bg = color.background_morelight
	end)

	button_created:connect_signal("button::release", function()
		button_created.bg = "#343b58"
	end)

	button_created:connect_signal("button::press", function(_, _, _, button)
		if button == 1 then
			widget_toggle.visible = not widget_toggle.visible
			awesome.emit_signal("widget::control")
		end
	end)

	return button_created
end

local power = create_button("power3.png", 8, 8, 13, 9, powermenu)
local notifications = create_button("notification.png", 7, 7, 6, 11, notif_center)


--Separator
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

--Main Widget
local buttons = wibox.widget {
	{
		{
			power,
			vertical_separator,
			notifications,
			layout = wibox.layout.fixed.horizontal,
		},
		widget = wibox.container.margin,
		top = dpi(6),
		bottom = dpi(6),
		right = dpi(6),
		left = dpi(6),
	},
	widget = wibox.container.background,
	bg = color.background_lighter,
	-- forced_height = 60,
	forced_width = dpi(104),
	halign = center,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 10)
	end,
}

return buttons
