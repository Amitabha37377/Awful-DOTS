local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local dpi = beautiful.xresources.apply_dpi

local helpers = require('helpers')
local color = require('themes.colors')
local user = require('user')

local create_btns = function(img, signal, signal2)
	local imgbox = helpers.imagebox(user.icon_path .. img .. '.svg', 50, 50)
	imgbox.valign = 'center'
	imgbox.halign = 'center'

	local btn = wibox.widget {
		{
			imgbox,
			widget = wibox.container.margin,
			margins = dpi(3)
		},
		widget = wibox.container.background,
		bg = color.bg_dim,
		shape = helpers.rrect(5),
	}
	helpers.add_hover_effect(btn, color.bg_normal, color.bg_light, color.bg_dim)

	local final_btn = helpers.margin(btn, 3, 3, 9, 9)
	final_btn.forced_width = dpi(70)
	final_btn:connect_signal("button::release", function(_, _, _, button)
		if button == 1 then
			awesome.emit_signal(signal)
		elseif button == 3 then
			awesome.emit_signal(signal2)
		end
	end)

	return final_btn
end

local btns = {
	launcher = create_btns('launch', 'launcher2::toggle', 'launcher2::toggle'),
	tasklist = create_btns('dockstation', 'tasklist::toggle', 'tasklist::toggle'),
	colorpicker = create_btns('gpick', 'picker::show', 'picker::pick')
}

return btns
