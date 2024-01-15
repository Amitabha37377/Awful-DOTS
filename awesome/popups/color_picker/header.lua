--Standard Modules
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local color = require("popups.color")

local header_text = wibox.widget {
	markup =
			'<span color="' ..
			color.yellow .. '" font="Ubuntu Nerd Font bold 18">' .. "    " .. '</span>' ..
			'<span color="' ..
			color.blue .. '" font="Ubuntu Nerd Font bold 18">' .. "Color picker" .. '</span>',
	widget = wibox.widget.textbox,
	halign = "left"
}

local clear_colors = wibox.widget {
	markup =
			'<span color="' ..
			color.red .. '" font="Ubuntu Nerd Font bold 22">' .. "  󰩺  " .. '</span>',
	widget = wibox.widget.textbox,
	halign = "left"

}

local header = wibox.widget {
	{
		{
			header_text,
			nil,
			clear_colors,
			layout = wibox.layout.align.horizontal
		},
		forced_height = dpi(50),
		forced_width = dpi(400),
		widget = wibox.container.margin,
		margins = dpi(6),
	},
	widget = wibox.container.background,
	bg = color.background_lighter
}

clear_colors:connect_signal("button::release", function(_, _, _, button)
	if button == 1 then
		awesome.emit_signal("clear::colors")
	end
end)



return header
