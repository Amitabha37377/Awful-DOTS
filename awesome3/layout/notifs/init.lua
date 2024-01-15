local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local ruled = require("ruled")
local naughty = require("naughty")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local color = require("themes.colors")
local helpers = require('helpers')
local user = require('user')
-----------------------
--Defaults-------------
-----------------------
naughty.config.defaults.ontop = true
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.border_width = 0
naughty.config.defaults.position = "top_right"
naughty.config.defaults.title = "Notification"
naughty.config.defaults.margin = dpi(16)

-----------------------
-- Rules---------------
-----------------------
ruled.notification.connect_signal('request::rules', function()
	-- Critical
	ruled.notification.append_rule {
		rule       = { urgency = 'critical' },
		properties = {
			bg = color.bg_dim,
			fg = color.fg_normal,
			timeout = 0,
		}
	}

	-- Normal
	ruled.notification.append_rule {
		rule       = { urgency = 'normal' },
		properties = {
			bg = beautiful.bg_dim,
			fg = color.fg_normal,
			timeout = 5,
		}
	}

	-- Low
	ruled.notification.append_rule {
		rule       = { urgency = 'low' },
		properties = {
			bg = beautiful.bg_dim,
			fg = color.fg_normal,
			timeout = 5,
		}
	}
end)

----------------------------
--Template------------------
----------------------------
local actions_template = wibox.widget {
	notification = n,
	base_layout = wibox.widget {
		spacing = dpi(0),
		layout  = wibox.layout.flex.horizontal
	},
	widget_template = {
		{
			{
				{
					{
						id     = 'text_role',
						font   = 'Ubuntu Nerd Font 12',
						widget = wibox.widget.textbox
					},
					widget = wibox.container.place
				},
				widget = wibox.container.background,
				bg = color.bg_normal
			},
			bg            = color.bg_normal,
			shape         = gears.shape.rounded_rect,
			forced_height = dpi(30),
			widget        = wibox.container.background
		},
		margins = dpi(6),
		widget  = wibox.container.margin
	},
	style = { underline_normal = false, underline_selected = true },
	widget = naughty.list.actions
}

--Template------------------
naughty.connect_signal("request::display", function(n)
	naughty.layout.box {
		notification = n,
		type = "notification",
		bg = beautiful.bg_normal,
		widget_template = {
			{
				{
					{
						{
							{
								{
									naughty.widget.title,
									font = "Ubuntu Nerd Font Bold 14",
									forced_height = dpi(20),
									layout = wibox.layout.align.horizontal
								},
								left = dpi(15),
								right = dpi(15),
								top = dpi(10),
								bottom = dpi(10),
								widget = wibox.container.margin
							},
							bg = color.bg_normal,
							widget = wibox.container.background
						},
						strategy = "min",
						width = dpi(300),
						widget = wibox.container.constraint
					},
					strategy = "max",
					width = dpi(400),
					widget = wibox.container.constraint
				},
				{
					{
						{
							{
								resize_strategy = 'center',
								widget = naughty.widget.icon or
										os.getenv("HOME") .. '/.config/awesome/deco/icons/notif.png'
							},
							margins      = beautiful.notification_margin,
							widget       = wibox.container.margin,
							-- forced_height = dpi(100),
							forced_width = dpi(100),
							top          = dpi(10),
							bottom       = dpi(5),
							left         = dpi(15),
							right        = dpi(10)
						},
						widget = wibox.container.background,
						bg = color.bg_dim

					},
					{
						{
							{
								{
									naughty.widget.message,
									left = dpi(15),
									right = dpi(15),
									top = dpi(10),
									bottom = dpi(10),
									widget = wibox.container.margin
								},
								widget = wibox.container.background,
								bg = color.bg_dim
							},
							strategy = "min",
							height = dpi(60),
							widget = wibox.container.constraint
						},
						strategy = "max",
						width = dpi(400),
						widget = wibox.container.constraint
					},
					layout = wibox.layout.align.horizontal
				},
				{
					actions_template,
					widget = wibox.container.margin,
					top = 0,
					bottom = 5,
					left = 10,
					right = 10
				},
				layout = wibox.layout.align.vertical
			},
			id = "background_role",
			widget = naughty.container.background,
			bg = color.bg_light
		}
	}

	--DND functionality
	if user.dnd_status == true then
		naughty.destroy_all_notifications(nil, 1)
	end
end)
