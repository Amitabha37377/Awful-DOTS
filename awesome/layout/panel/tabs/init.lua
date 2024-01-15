local awful = require 'awful'
local beautiful = require 'beautiful'
local wibox = require 'wibox'
local dpi = beautiful.xresources.apply_dpi

local helpers = require 'helpers'
local color = require 'themes.colors'

local ctrl = ''
local wthr = ''
local td = ''
local stngs = ''

local text_wgt = function(icon)
	local text = helpers.textbox(color.fg_normal, "Ubuntu nerd font bold 20", icon)
	text.valign = 'center'
	text.halign = 'center'

	return text
end

local control_txt = text_wgt(ctrl)
local weather_txt = text_wgt(wthr)
local todo_txt = text_wgt(td)
local settings_txt = text_wgt(stngs)

local create_container = function(wgt)
	local container = wibox.widget {
		helpers.margin(wgt, 20, 20, 10, 10),
		widget = wibox.container.background,
		bg = color.bg_normal,
	}
	container.forced_width = dpi(450 / 4)
	container.txt_wgt = wgt
	return container
end

local control = create_container(control_txt)
local weather = create_container(weather_txt)
local todo = create_container(todo_txt)
local settings = create_container(settings_txt)

control.bg = color.blue
control_txt.markup = helpers.mtext(color.bg_dark, 'Ubuntu nerd font bold 20', '')

local tabs = wibox.widget {
	{
		{
			control,
			weather,
			todo,
			settings,
			layout = wibox.layout.fixed.horizontal
		},
		widget = wibox.container.place
	},
	widget = wibox.container.margin,
	forced_width = dpi(450)
}

local set_bg = function(btn)
	control.bg = color.bg_normal
	weather.bg = color.bg_normal
	todo.bg = color.bg_normal
	settings.bg = color.bg_normal
	btn.bg = color.blue

	control_txt.markup = helpers.mtext(color.fg_normal, "Ubuntu nerd font bold 20", ctrl)
	weather_txt.markup = helpers.mtext(color.fg_normal, "Ubuntu nerd font bold 20", wthr)
	todo_txt.markup = helpers.mtext(color.fg_normal, "Ubuntu nerd font bold 20", td)
	settings_txt.markup = helpers.mtext(color.fg_normal, "Ubuntu nerd font bold 20", stngs)

	if btn.txt_wgt == control_txt then
		control_txt.markup = helpers.mtext(color.bg_dark, "Ubuntu nerd font bold 20", ctrl)
	elseif btn.txt_wgt == weather_txt then
		weather_txt.markup = helpers.mtext(color.bg_dark, "Ubuntu nerd font bold 20", wthr)
	elseif btn.txt_wgt == todo_txt then
		todo_txt.markup = helpers.mtext(color.bg_dark, "Ubuntu nerd font bold 20", td)
	elseif btn.txt_wgt == settings_txt then
		settings_txt.markup = helpers.mtext(color.bg_dark, "Ubuntu nerd font bold 20", stngs)
	end
end

local function create_signals(signal, btn)
	awesome.connect_signal(signal, function()
		set_bg(btn)
	end)
end

local select = function(btn, signal)
	btn:connect_signal("button::release", function()
		set_bg(btn)
		awesome.emit_signal(signal)
	end)
end

create_signals("bg::control", control)
create_signals("bg::weather", weather)
create_signals("bg::todo", todo)
create_signals("bg::settings", settings)

select(control, 'panel::control')
select(weather, 'panel::calendar')
select(todo, 'panel::todo')
select(settings, 'panel::settings')

return tabs
