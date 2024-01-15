local awful = require 'awful'
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local dpi = beautiful.xresources.apply_dpi

local color = require 'themes.colors'
local helpers = require 'helpers'

local button_text = helpers.textbox(color.lightblue, 'Ubuntu nerd font bold 22', '󰀻')
button_text.valign = "center"
button_text.halign = "center"


local button_bg = wibox.widget {
	{
		button_text,
		widget = wibox.container.margin,
		margins = dpi(5)
	},
	widget = wibox.container.background,
	bg = color.bg_dim,
	shape = helpers.rrect(dpi(4))

}

local button_final = helpers.margin(button_bg, 5, 5, 5, 5)

helpers.add_hover_effect(button_bg, color.bg_normal, color.bg_light, color.bg_dim)
button_final.forced_width = dpi(50)

button_final:connect_signal("button::release", function(_, _, _, button)
	if button == 1 then
		awesome.emit_signal('open::window')
	end
end)


return button_final
