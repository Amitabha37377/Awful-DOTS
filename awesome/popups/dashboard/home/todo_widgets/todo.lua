--Standard Modules
local awful          = require("awful")
local wibox          = require("wibox")
local gears          = require("gears")
local beautiful      = require("beautiful")
local dpi            = beautiful.xresources.apply_dpi

--Custom Modules
local color          = require("popups.color")

-----------------------
--Header text----------
-----------------------

local create_textbox = function(font, text, fg_color)
	local textbox = wibox.widget {
		markup = '<span color="' ..
				fg_color .. '" font="' .. font .. '">' .. text .. '</span>',
		widget = wibox.widget.textbox,
	}
	return textbox
end

local header         = create_textbox("Ubuntu nerd font bold 16", "  To Do List", color.magenta)
local add_task       = create_textbox("Ubuntu nerd font bold 16", "    ", color.green)
local remove_all     = create_textbox("Ubuntu nerd font bold 16", "    ", color.red)
local prompt_textbox = create_textbox("Ubuntu nerd font bold 16", "   Add task  ", color.grey)

local top_header     = wibox.widget {
	{
		{
			header,
			nil,
			{
				add_task,
				remove_all,
				layout = wibox.layout.fixed.horizontal
			},
			layout = wibox.layout.align.horizontal
		},
		widget = wibox.container.margin,
		top = dpi(7),
		bottom = dpi(5),
		right = dpi(5),
		left = dpi(8),
	},
	widget = wibox.container.background,
	bg = color.background_lighter,
	shape = function(cr, width, height)
		gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, 7)
	end,
}

local prompt_box     = wibox.widget {
	{
		prompt_textbox,
		widget = wibox.container.margin,
		margins = dpi(15),
		forced_width = dpi(410)
	},
	widget = wibox.container.background,
	bg = color.background_lighter2,
	border_width = dpi(2),
	border_color = color.background_lighter,
	shape = function(cr, width, height)
		gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, 7)
	end,

}
local todocontainer  = wibox.widget {
	spacing = dpi(0),
	layout = wibox.layout.fixed.vertical,
	-- layout = require("overflow").vertical,
	visible = true,
	step = 50,
	scrollbar_enabled = true,
	forced_height = dpi(500)
}

local todo_empty     = wibox.widget {
	{
		nil,
		{
			{
				image = os.getenv("HOME") .. "/.config/awesome/popups/dashboard/home/todo_widgets/icons/todo.png",
				widget = wibox.widget.imagebox,
				forced_height = dpi(160),
				forced_width = dpi(160),
				resize = true
			},
			create_textbox("Ubuntu nerd font bold 20", "\nNo tasks to do", color.blueish_white),
			layout = wibox.layout.fixed.vertical
		},
		nil,
		layout = wibox.layout.align.vertical
	},
	widget = wibox.container.place,
	forced_height = dpi(540)
}

local final_widget   = wibox.widget {
	{
		top_header,
		{
			todocontainer,
			widget = wibox.container.background,
			bg = color.background_lighter
		},
		prompt_box,
		layout = wibox.layout.fixed.vertical
	},
	widget = wibox.container.margin,
	top = dpi(2),
	bottom = dpi(12),
	left = dpi(12),
	right = dpi(12)
}

todocontainer:insert(1, todo_empty)

-- Make todo tasks
local create_todo = function(text)
	local todo_text       = create_textbox("Ubuntu nerd font 15", text, color.blueish_white)
	local complete        = create_textbox("Ubuntu nerd font 13", "  Done", color.magenta)
	local remove          = create_textbox("Ubuntu nerd font 13", " 󱘜 remove", color.yellow)

	local complete_button = wibox.widget { {
		{
			complete,
			widget = wibox.container.place,
		},
		widget = wibox.container.margin,
		margins = dpi(15)
	},
		widget = wibox.container.background,
		bg = color.background_lighter,
		border_width = dpi(10),
		border_color = "#30364f" }

	local remove_button   = wibox.widget { {
		{
			remove,
			widget = wibox.container.place,
		},
		widget = wibox.container.margin,
		margins = dpi(15)
	},
		widget = wibox.container.background,
		bg = color.background_lighter,
		border_width = dpi(10),
		border_color = "#30364f" }


	local todo_template = wibox.widget {
		{
			{
				todo_text,
				widget = wibox.container.margin,
				top = dpi(15),
				bottom = dpi(0),
				left = dpi(15),
				right = dpi(15),
				forced_width = dpi(410),
			},
			{
				complete_button,
				remove_button,
				layout = wibox.layout.flex.horizontal
			},
			layout = wibox.layout.fixed.vertical
		},
		widget = wibox.container.background,
		bg = "#30364f",
		border_width = dpi(2),
		border_color = color.background_lighter
	}

	local hover_effects = function(buttons)
		buttons:connect_signal("mouse::enter", function()
			buttons.bg = "#26303b"
		end)
		buttons:connect_signal("mouse::leave", function()
			buttons.bg = color.background_lighter
		end)
		buttons:connect_signal("mouse::release", function(_, _, _, button)
			if button == 1 then
				buttons.bg = color.background_lighter2
			end
		end)
		buttons:connect_signal("button::press", function(_, _, _, button)
			if button == 1 then
				buttons.bg = "#30425c"
			end
		end)
	end

	hover_effects(remove_button)
	hover_effects(complete_button)

	remove_button:connect_signal("button::release", function(_, _, _, button)
		if button == 1 then
			todocontainer:remove_widgets(todo_template)
			if #todocontainer.children == 0 then
				todocontainer:insert(1, todo_empty)
			end
		end
	end)

	complete_button:connect_signal("button::release", function(_, _, _, button)
		if button == 1 then
			todo_text.markup = '<span color="' ..
					color.blueish_white ..
					'" font="' .. "Ubuntu nerd font 15" .. '">' .. "<s>" .. text .. "</s>" .. '</span>'
		end
	end)

	return todo_template
end



-- Prompt run function
local add_todo = function()
	awful.prompt.run {
		textbox = prompt_textbox,
		exe_callback = function(input)
			local new_todo = create_todo(input)
			todocontainer:remove_widgets(todo_empty)
			todocontainer:insert(1, new_todo)
			prompt_textbox.markup = '<span color="' ..
					color.grey .. '" font="' .. "Ubuntu nerd font bold 16" .. '">' .. "   Add task" .. '</span>'
		end
	}
end

-- Add todo
prompt_box:connect_signal("button::release", function(_, _, _, button)
	if button == 1 then
		add_todo()
	end
end)

add_task:connect_signal("button::release", function(_, _, _, button)
	if button == 1 then
		add_todo()
	end
end)

--CLear all todo
remove_all:connect_signal("button::release", function(_, _, _, button)
	if button == 1 then
		todocontainer:reset(todocontainer)
		todocontainer:insert(1, todo_empty)
	end
end)

--Scroll
todocontainer:buttons(
	gears.table.join(
		awful.button({}, 4, nil, function()
			if #todocontainer.children == 1 then
				return
			end
			todocontainer:insert(1, todocontainer.children[#todocontainer.children])
			todocontainer:remove(#todocontainer.children)
		end),

		awful.button({}, 5, nil, function()
			if #todocontainer.children == 1 then
				return
			end
			todocontainer:insert(#todocontainer.children + 1, todocontainer.children[1])
			todocontainer:remove(1)
		end)
	)
)



return final_widget
