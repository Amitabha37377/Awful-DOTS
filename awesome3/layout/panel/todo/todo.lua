local awful          = require 'awful'
local wibox          = require 'wibox'
local gears          = require 'gears'
local beautiful      = require 'beautiful'
local dpi            = beautiful.xresources.apply_dpi

local color          = require 'themes.colors'
local helpers        = require 'helpers'

local header         = helpers.textbox(color.lightblue, "Ubuntu nerd font bold 16", "To Do List")
local add            = helpers.textbox(color.green, "Ubuntu nerd font bold 18", "    ")
local remove_all     = helpers.textbox(color.red, "Ubuntu nerd font bold 18", "    ")

local todocontainer  = wibox.widget {
	layout = require('modules.overflow').vertical,
	forced_height = dpi(450),
	step = 50,
	scrollbar_enabled = true
}

local empty_visible  = true

local task_done      = 0
local task_remaining = #todocontainer.children - task_done

local txt_done       = helpers.textbox(color.blue, "Ubuntu nerd font bold 34", task_done)
local txt_remaining  = helpers.textbox(color.yellow, "Ubuntu nerd font bold 34", task_remaining)

local update         = function()
	txt_done.markup = helpers.mtext(color.blue, "Ubuntu nerd font bold 34", task_done)
	if not empty_visible then
		txt_remaining.markup = helpers.mtext(color.yellow, "Ubuntu nerd font bold 34", #todocontainer.children - task_done)
	else
		txt_remaining.markup = helpers.mtext(color.yellow, "Ubuntu nerd font bold 34",
			'0')
	end
end

update()

local promptbox = helpers.textbox(color.mid_light, "Ubuntu nerd font bold 16", "       Add new task here")
local prompt    = wibox.widget {
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
	forced_height = dpi(450)
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
	final_todo.done = false

	checkbox:connect_signal("button::release", function(_, _, _, button)
		if button == 1 then
			final_todo.done = true
			if final_todo.done then
				checkbox.markup = helpers.mtext(color.blue, "Ubuntu nerd font bold 20", ' 󰄲 ')
				task_done = task_done + 1
				update()
			end
		end
	end)

	final_todo:connect_signal("button::release", function(_, _, _, button)
		if button == 3 then
			todocontainer:remove_widgets(final_todo)
			if #todocontainer.children == 0 then
				todocontainer:insert(1, todo_empty)
				empty_visible = true
				task_done = 0
				update()
			end
			if final_todo.done then
				task_done = task_done - 1
				update()
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
			empty_visible = false
			todocontainer:insert(1, new_todo)
			promptbox.markup = helpers.mtext(color.mid_light, "Ubuntu nerd font bold 16", "       Add new task here")
			update()
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
		empty_visible = true
		task_done = 0
		update()
	end
end)

local task_status           = wibox.widget {
	{
		helpers.margin(
			{
				txt_done,
				helpers.textbox(color.blue, "Ubuntu nerd font bold 14", "Tasks\nCompleted"),
				spacing = dpi(10),
				layout = wibox.layout.fixed.horizontal
			},
			20, 10, 10, 10
		),
		widget = wibox.container.background,
		bg = color.bg_normal,
		shape = helpers.rrect(10)
	},
	widget = wibox.container.margin,
	bottom = dpi(20),
	right = dpi(5),
}

local task_status_remaining = wibox.widget {
	{
		helpers.margin(
			{
				txt_remaining,
				helpers.textbox(color.yellow, "Ubuntu nerd font bold 14", "Tasks\nRemaining"),
				spacing = dpi(10),
				layout = wibox.layout.fixed.horizontal
			},
			20, 10, 10, 10
		),
		widget = wibox.container.background,
		bg = color.bg_normal,
		shape = helpers.rrect(10)
	},
	widget = wibox.container.margin,
	bottom = dpi(15),
	left = dpi(5)
}


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

local final        = helpers.margin(
	{
		{ task_status, task_status_remaining, layout = wibox.layout.flex.horizontal },
		todo,
		layout = wibox.layout.fixed.vertical
	}, 10, 10, 10, 10)
final.forced_width = dpi(450)

return final
