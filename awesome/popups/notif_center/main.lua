--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")

--Custom Modules
local color = require("popups.color")
local header_text = require("popups.notif_center.header.header")
local header_buttons = require("popups.notif_center.header.button")

local Separator = wibox.widget.textbox("    ")
Separator.forced_height = dpi(11)

local horizonta_separator = wibox.widget {
	orientation = 'horizontal',
	forced_height = dpi(1.5),
	forced_width = dpi(1.5),
	span_ratio = 0.85,
	widget = wibox.widget.separator,
	color = "#a9b1d6",
	border_color = "#a9b1d6",
	opacity = 0.55
}


--Notification center
local notifscontainer = wibox.widget {
	spacing = dpi(15),
	layout = wibox.layout.fixed.vertical,
	forced_height = dpi(900),
	forced_width = dpi(410)
}

local notifsempty = wibox.widget {
	nil,
	{
		nil,
		{
			{
				{
					{
						widget = wibox.widget.imagebox,
						image = os.getenv("HOME") .. '/.config/awesome/popups/notif_center/assets/bell.png',
						resize = true,
						forced_height = dpi(70),
						forced_width = dpi(70)
					},
					widget = wibox.container.place
				},
				Separator,
				{
					-- text = "No Notifications",
					markup = '<span color="' ..
							color.blueish_white .. '" font="Ubuntu Nerd Font Bold 16">' .. 'NO NOTIFICATION YET' .. '</span>',
					align = "center",
					valign = "center",
					widget = wibox.widget.textbox
				},
				layout = wibox.layout.fixed.vertical
			},
			widget = wibox.container.place
		},
		layout = wibox.layout.align.horizontal
	},
	forced_height = dpi(900), --fix this?
	forced_width = dpi(410),
	layout = wibox.layout.align.vertical
}

local notifsemptyvisible = true

removenotif = function(box)
	notifscontainer:remove_widgets(box)

	if #notifscontainer.children == 0 then
		notifscontainer:insert(1, notifsempty)
		notifsemptyvisible = true
	end
end




local createnotif = function(n)
	local time = os.date("%H:%M")

	local clear = wibox.widget
			{ {
				{
					widget = wibox.widget.textbox,
					markup = '<span color="' ..
							"#e36f84" .. '" font="Ubuntu Nerd Font bold 15">' .. "󰅙" .. '</span>',
				},
				widget = wibox.container.margin,
				top = dpi(10),
				bottom = dpi(10),
				right = dpi(15),
				left = dpi(15),
				forced_width = dpi(52)
			},
				widget = wibox.container.background,
				bg = "#1f1f2f" }

	local box = wibox.widget {
		{
			{
				{
					{
						{
							{
								{
									{
										markup = '<span color="#a9b1d6" font="Ubuntu nerd font 14 bold">' ..
												n.title .. '</span>',
										align = "left",
										widget = wibox.widget.textbox
									},
									strategy = "exact",
									width = dpi(230),
									height = dpi(20),
									widget = wibox.container.constraint
								},
								nil,
								{
									markup = '<span color="#a9b1d6">' .. time .. '</span>',
									align = "right",
									widget = wibox.widget.textbox
								},
								layout = wibox.layout.align.horizontal
							},
							widget = wibox.container.margin,
							top = dpi(10),
							bottom = dpi(10),
							left = dpi(15),
							right = dpi(15),
							forced_width = dpi(365)
						},
						widget = wibox.container.background,
						bg = "#222236"
					},
					clear,
					layout = wibox.layout.fixed.horizontal
				},
				{
					{
						{
							{
								{
									widget = wibox.widget.imagebox,
									image = n.icon,
									align = "right",
									resize = true,
									resize_strategy = "center"
								},
								widget = wibox.container.margin,
								top = dpi(5),
								bottom = dpi(5),
								left = dpi(0),
								right = dpi(15),
								forced_height = dpi(50),
								-- forced_width = dpi(100)
							},
							{
								markup = '<span color="#a9b1d6">' .. n.message .. '</span>',
								align = "left",
								widget = wibox.widget.textbox
							},

							layout = wibox.layout.fixed.horizontal
						},
						widget = wibox.container.margin,
						-- margins = dpi(15)
						top = dpi(15),
						left = dpi(15),
						right = dpi(15),
						bottom = dpi(10),
						-- forced_height = dpi(80)
					},
					widget = wibox.container.background,
					bg = color.background_lighter
				},
				{
					{
						notification = n,
						base_layout = wibox.widget {
							spacing = dpi(1),
							-- spacing_widget = wibox.widget {
							-- 	orientation = "horizontal",
							-- 	widget      = wibox.widget.separator,
							-- },
							layout  = wibox.layout.flex.horizontal,
							-- widget  = wibox.container.margin,
							-- right   = dpi(15)
						},
						style = {
							underline_normal   = false,
							underline_selected = false,
							fg_normal          = color.white,
							fg_selected        = color.blue,
						},
						widget_template = {
							{
								{
									{
										{
											id     = "text_role",
											widget = wibox.widget.textbox
										},
										widget = wibox.container.place
									},
									widget = wibox.container.margin,
									top = dpi(3),
									bottom = dpi(3),
									left = dpi(3),
									right = dpi(3)
								},
								shape              = gears.shape.rounded_rect,
								shape_border_width = 2,
								shape_border_color = beautiful.bg_normal,
								forced_height      = 36,
								widget             = wibox.container.background,
								bg                 = "#1f1f2f"
							},
							top    = dpi(0),
							left   = dpi(3),
							right  = dpi(3),
							bottom = dpi(9),
							widget = wibox.container.margin,
						},
						widget = naughty.list.actions,
					},
					widget = wibox.container.margin,
					left = dpi(11),
					right = dpi(11)
				},
				spacing = dpi(0),
				layout = wibox.layout.fixed.vertical
			},
			margins = dpi(0),
			widget = wibox.container.margin,
			maximum_height = dpi(160)
		},
		bg = color.background_lighter,
		widget = wibox.container.background,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 7)
		end,

	}

	-- clear:buttons(
	-- 	gears.table.join(
	-- 		awful.button({}, 1, function()
	-- 			_G.removenotif(box)
	-- 		end)
	-- 	)
	-- )
	clear:connect_signal("mouse::enter", function()
		clear.bg = "#272736"
	end)

	clear:connect_signal("mouse::leave", function()
		clear.bg = '#1f1f2f'
	end)

	clear:connect_signal("button::press", function()
		clear.bg = "#323242"
	end)

	clear:connect_signal("button::release", function()
		clear.bg = "#272736"
		_G.removenotif(box)
	end)


	return box
end

notifscontainer:buttons(
	gears.table.join(
		awful.button({}, 4, nil, function()
			if #notifscontainer.children == 1 then
				return
			end
			notifscontainer:insert(1, notifscontainer.children[#notifscontainer.children])
			notifscontainer:remove(#notifscontainer.children)
		end),

		awful.button({}, 5, nil, function()
			if #notifscontainer.children == 1 then
				return
			end
			notifscontainer:insert(#notifscontainer.children + 1, notifscontainer.children[1])
			notifscontainer:remove(1)
		end)
	)
)

-- Notification center setup

notifscontainer:insert(1, notifsempty)



naughty.connect_signal("request::display", function(n)
	if #notifscontainer.children == 1 and notifsemptyvisible then
		notifscontainer:reset(notifscontainer)
		notifsemptyvisible = false
	end

	notifscontainer:insert(1, createnotif(n))
end)

local notifs = wibox.widget {
	notifscontainer,
	spacing = dpi(15),
	visible = true,
	layout = wibox.layout.fixed.vertical
}


--Main Wibox
local notif_center_popup = awful.popup {
	screen = s,
	widget = wibox.container.background,
	ontop = true,
	bg = "#00000000",
	visible = false,
	forced_width = 200,
	maximum_height = 900,
	placement = function(c)
		awful.placement.top_right(c,
			{ margins = { top = dpi(43), bottom = dpi(8), left = dpi(8), right = dpi(8) } })
	end,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 0)
	end,
	opacity = 1
}

notif_center_popup:setup { {
	{
		{
			{
				header_text,
				Separator,
				header_buttons,
				layout = wibox.layout.fixed.horizontal
			},
			widget = wibox.container.margin,
			top    = dpi(15),
			bottom = dpi(18),
			left   = dpi(15),
			right  = dpi(15)
		},
		horizonta_separator,
		{
			{
				notifs,
				layout = wibox.layout.stack
			},
			margins = dpi(15),
			widget = wibox.container.margin
		},
		layout = wibox.layout.align.vertical
	},
	valign = "top",
	layout = wibox.container.place
},
	widget = wibox.container.background,
	bg = "#181825",
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 10)
	end,

}

awesome.connect_signal("widget::notif_close", function()
	notif_center_popup.visible = not notif_center_popup.visible
end)


awesome.connect_signal("notif::clearall", function()
	notifscontainer:reset(notifscontainer)
	notifsemptyvisible = true
	notifscontainer:insert(1, notifsempty)
end)


return notif_center_popup
