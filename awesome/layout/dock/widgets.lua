local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local dpi = beautiful.xresources.apply_dpi

local helpers = require('helpers')
local color = require('themes.colors')
local user = require('user')

local create_btns = function(img, signal)
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
		bg = color.bg_dark,
		shape = helpers.rrect(5),
	}
	helpers.add_hover_effect(btn, color.bg_dim, color.bg_normal, color.bg_dark)

	local final_btn = helpers.margin(btn, 3, 3, 9, 9)
	final_btn.forced_width = dpi(70)
	final_btn:connect_signal("button::release", function(_, _, _, button)
		if button == 1 then
			awesome.emit_signal(signal)
		end
	end)

	return final_btn
end

local btns = {
	launcher = create_btns('launch', 'widget::launcher'),
	tasklist = create_btns('dockstation', 'tasklist::toggle'),
	colorpicker = create_btns('gpick', 'picker::show')
}

btns.colorpicker:connect_signal("button::release", function(_, _, _, button)
	if button == 3 then
		awesome.emit_signal("picker::pick")
	end
end)


return btns
