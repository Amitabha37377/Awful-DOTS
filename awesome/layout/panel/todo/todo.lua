local awful         = require 'awful'
local wibox         = require 'wibox'
local gears         = require 'gears'
local beautiful     = require 'beautiful'
local dpi           = beautiful.xresources.apply_dpi

local color         = require 'themes.colors'
local helpers       = require 'helpers'

local header        = helpers.textbox(color.purple, "Ubuntu nerd font bold 16", "To Do List")
local add           = helpers.textbox(color.purple, "Ubuntu nerd font bold 18", "    ")
local remove_all    = helpers.textbox(color.red, "Ubuntu nerd font bold 18", "    ")

local todocontainer = wibox.widget {
	layout = require('modules.overflow').vertical,
	forced_height = dpi(540),
	step = 50,
	scrollbar_enabled = true
}

local promptbox     = helpers.textbox(color.mid_light, "Ubuntu nerd font bold 16", "       Add new task here")
local prompt        = wibox.widget {
	{
		promptbox,
		widget = wibox.container.margin,
		margins = dpi(10),
		forced_height = dpi(100)
	},
	widget = wibox.container.background,
	bg = color.bg_light,
	shape = helpers.part_rrect(false, false, true, true, 15),
	border_width = dpi(5),
	border_color = color.bg_normal
}


local todo_empty = wibox.widget {
	{
		nil,
		{
			{
				image = os.getenv("HOME") .. "/.config/awesome/assets/others/todo.png",
				widget = wibox.widget.imagebox,
				forced_height = dpi(160),
				forced_width = dpi(160),
				resize = true
			},
			helpers.textbox(color.lightblue, "Ubuntu nerd font bold 20", "\nNo tasks to do"),
			layout = wibox.layout.fixed.vertical
		},
		nil,
		layout = wibox.layout.align.vertical
	},
	widget = wibox.container.place,
	forced_height = dpi(540)
}

todocontainer:insert(1, todo_empty)

local create_todo = function(text)
	local todo = helpers.textbox(color.fg_normal, "Ubuntu nerd font 15", text)
	local checkbox = helpers.textbox(color.blue, "Ubuntu nerd font bold 20", ' 󰄱 ')
	checkbox.valign = 'top'

	local final = {
		{
			{
				helpers.margin({ checkbox, layout = wibox.layout.fixed.vertical }, 0, 6, 0, 0),
				todo,
				layout = wibox.layout.fixed.horizontal
			},
			widget = wibox.container.margin,
			margins = dpi(5)
		},
		widget = wibox.container.constraint,
		strategy = 'max',
		height = dpi(450)
	}

	local final_todo = helpers.margin(final, 10, 10, 5, 5)

	checkbox:connect_signal("button::release", function(_, _, _, button)
		if button == 1 then
			checkbox.markup = helpers.mtext(color.blue, "Ubuntu nerd font bold 20", ' 󰄲 ')
		end
	end)

	final_todo:connect_signal("button::release", function(_, _, _, button)
		if button == 3 then
			todocontainer:remove_widgets(final_todo)
			if #todocontainer.children == 0 then
				todocontainer:insert(1, todo_empty)
			end
		end
	end)

	return final_todo
end

local add_todo    = function()
	awful.prompt.run {
		textbox = promptbox,
		exe_callback = function(input)
			local new_todo = create_todo(input)
			todocontainer:remove_widgets(todo_empty)
			todocontainer:insert(1, new_todo)
			promptbox.markup = helpers.mtext(color.mid_light, "Ubuntu nerd font bold 16", "       Add new task here")
		end

	}
end

prompt:connect_signal("button::release", function(_, _, _, button)
	if button == 1 then
		add_todo()
	end
end)

add:connect_signal("button::release", function(_, _, _, button)
	if button == 1 then
		add_todo()
	end
end)

remove_all:connect_signal("button::release", function(_, _, _, button)
	if button == 1 then
		todocontainer:reset()
		todocontainer:insert(1, todo_empty)
	end
end)

--------------------------
--Main WIdget-------------
--------------------------
local todo         = wibox.widget {
	{
		{
			{
				header,
				nil,
				{ add, remove_all, layout = wibox.layout.fixed.horizontal },
				layout = wibox.layout.align.horizontal
			},
			widget = wibox.container.margin,
			margins = dpi(20)
		},
		{
			todocontainer,
			widget = wibox.container.background,
			bg = color.bg_normal
		},
		prompt,
		layout = wibox.layout.fixed.vertical
	},
	widget = wibox.container.background,
	bg = color.bg_normal,
	shape = helpers.rrect(15)
}

local final        = helpers.margin(todo, 10, 10, 10, 10)
final.forced_width = dpi(450)

return final
