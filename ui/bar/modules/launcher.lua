local wibox = require 'wibox'
local beautiful = require 'beautiful'
local dpi = beautiful.xresources.apply_dpi

local helpers = require 'helpers'
local color = require 'themes.colors'

local button_text = helpers.textbox(color.blue, 'Ubuntu nerd font bold 24', '󰀻')
local button_bg = wibox.widget {
	{
		button_text,
		widget = wibox.container.margin,
		margins = dpi(5)
	},
	widget = wibox.container.background,
	bg = color.bg_normal,
	shape = helpers.rrect(dpi(4))

}

local button_final = helpers.margin(button_bg, 6, 6, 6, 6)
helpers.add_hover_effect(button_bg, color.bg_light, color.mid_dark, color.bg_normal)

button_final:connect_signal("button::release", function(_, _, _, button)
	if button == 1 then
		awesome.emit_signal('widget::launcher')
	end
end)


return button_final
