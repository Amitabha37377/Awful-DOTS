--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")
local color = require("popups.color")

local blankbox = wibox.widget.textbox("    ")
blankbox.forced_height = dpi(60)
blankbox.forced_width = dpi(85)

local header = require("popups.color_picker.header")

-----------------------------
--empty_box------------------
-----------------------------
local empty_box = wibox.widget {
	{
		{
			{
				{
					widget = wibox.widget.imagebox,
					image = os.getenv("HOME") .. "/.config/awesome/popups/color_picker/assets/empty.png",
					forced_width = dpi(80),
					forced_height = dpi(80),
					halign = "center"
				},
				widget = wibox.container.margin,
				margins = dpi(20)
			},
			{
				markup =
						'<span color="' ..
						color.magenta ..
						'" font="Ubuntu Nerd Font bold 16">' .. "<i>Picked colors will be\nshown here</i>" .. '</span>',
				widget = wibox.widget.textbox,
				halign = "center"
			},
			layout = wibox.layout.fixed.vertical
		},
		widget = wibox.container.place
	},
	widget = wibox.container.margin,
	margins = dpi(3),
	forced_height = dpi(295),
	forced_width = dpi(400) }

----------------------------------
-- Widget that stores color-------
----------------------------------
local colorlist = wibox.widget {
	layout = wibox.layout.grid,
	forced_num_cols = 4,
	forced_num_rows = 3,
	homogenous = true,
	spacing = dpi(20),
	forced_height = dpi(295),
	forced_width = dpi(400),
}


local color_table = {}

local add_to_table = function(box)
	table.insert(color_table, box)
	for i = #color_table, 1, -1
	do
		colorlist:add(color_table[i])
	end
end

local create_colorbox = function(pickedcolor)
	local colorbox = wibox.widget {
		{
			{
				blankbox,
				widget = wibox.container.background,
				bg     = pickedcolor
			},
			{
				{
					widget = wibox.widget.textbox,
					markup = '<span color="' ..
							color.blueish_white .. '" font="Ubuntu Nerd Font bold 12">' .. pickedcolor .. '</span>',
					forced_height = dpi(25),
					halign = "center"
				},
				widget = wibox.container.background,

				bg = "#00000080",
			},

			layout = wibox.layout.fixed.vertical
		},
		widget = wibox.container.background,
		bg = pickedcolor,
	}

	colorbox:connect_signal("button::release", function(_, _, _, button)
		if button == 1 then
			awful.spawn.with_shell("xclip -r -sel c << EOF\n" .. pickedcolor)
		end
	end)

	return colorbox
end


--------------------------------
--Main popup window-------------
--------------------------------
local window = awful.popup {
	screen = s,
	widget = wibox.container.background,
	ontop = true,
	bg = "#00000000",
	visible = false,
	placement = function(c)
		awful.placement.bottom_right(c,
			{ margins = { top = dpi(0), bottom = dpi(70), left = dpi(0), right = dpi(400) } })
	end,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 0)
	end,
	opacity = 1
}

window:setup({
	{
		header,
		{
			{
				empty_box,
				colorlist,
				layout = wibox.layout.stack
			},
			widget = wibox.container.margin,
			margins = dpi(20),
			ontop = true
		},
		layout = wibox.layout.fixed.vertical
	},
	widget = wibox.container.background,
	bg = color.background_dark,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 8)
	end,

})

-----------------------------
--Toggle button--------------
-----------------------------
local toggleButton = wibox.widget {
	{
		{
			widget = wibox.widget.imagebox,
			image = os.getenv("HOME") .. "/.icons/Papirus/32x32/apps/" .. "gpick.svg",
			resize = true,
			opacity = 1,
		},
		left   = dpi(4),
		right  = dpi(0),
		top    = dpi(4),
		bottom = dpi(4),
		widget = wibox.container.margin
	},
	bg = color.background_dark,
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
	forced_height = dpi(48),
	forced_width = dpi(48),

}

-------------------------------
--Button Functionalities-------
-------------------------------
toggleButton:connect_signal("button::release", function(_, _, _, button)
	if button == 1 then
		window.visible = not window.visible
	elseif button == 3 then
		awful.spawn.easy_async("gpick -s -o", function(out)
			if out:len() > 0 then
				awful.spawn.with_shell("xclip -r -sel c << EOF\n" .. out .. "EOF")

				naughty.notification {
					title = "Color picker",
					message = "Picked color: " .. out:gsub("\n", ""),
					icon = os.getenv("HOME") .. "/.config/awesome/popups/color_picker/assets/pick.png"
				}
				local hex_color = out:match("#%x%x%x%x%x%x")

				if hex_color then
					local colornew = create_colorbox(hex_color)
					empty_box.visible = false
					colorlist:reset()
					add_to_table(colornew)
				else
					naughty.notify({ text = "Invalid color code received. " .. out })
				end
			else
				naughty.notification {
					title = "Color picker",
					message = "Canceled."
				}
			end
		end)
	end
end)

--CLear all colors
awesome.connect_signal("clear::colors", function()
	colorlist:reset()
	for k in pairs(color_table) do
		color_table[k] = nil
	end
	empty_box.visible = true
end)

return toggleButton
