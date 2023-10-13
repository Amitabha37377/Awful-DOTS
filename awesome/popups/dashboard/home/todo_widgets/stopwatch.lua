local awful            = require("awful")
local gears            = require("gears")
local beautiful        = require("beautiful")
local wibox            = require("wibox")
local dpi              = beautiful.xresources.apply_dpi
local naughty          = require("naughty")
local color            = require("popups.color")

local create_textbox   = function(font, text, fg_color)
	local textbox = wibox.widget {
		markup = '<span color="' ..
				fg_color .. '" font="' .. font .. '">' .. text .. '</span>',
		widget = wibox.widget.textbox,

	}

	return textbox
end

local time             = create_textbox("Ubuntu Nerd Font bold 66", "00 : 00", color.green)
local add_timer        = create_textbox("Ubuntu Nerd Font bold 16", "  Add timer", color.magenta)
local set_timer_button = create_textbox("Ubuntu Nerd Font bold 16", "  󱎫  ", color.magenta)


local create_button     = function(icon)
	local button_bg = wibox.widget {
		{
			icon,
			widget = wibox.container.margin,
			margins = dpi(3)
		},
		widget = wibox.container.background,
		bg = color.background_lighter
	}

	local button = wibox.widget {
		button_bg,
		widget = wibox.container.margin,
		left   = dpi(22),
		right  = dpi(22),
		top    = dpi(2),
		bottom = dpi(2)
	}
	button:connect_signal("mouse::enter", function()
		button_bg.bg = color.background_lighter2
	end)

	button:connect_signal("mouse::leave", function()
		button_bg.bg = color.background_lighter
	end)

	button:connect_signal("button::press", function()
		button_bg.bg = color.background_morelight
	end)

	button:connect_signal("button::release", function()
		button_bg.bg = color.background_lighter2
	end)

	return button
end

local play_pause        = create_textbox("Ubuntu nerd font  bold 20", "  ", color.yellow)
local reset             = create_textbox("Ubuntu nerd font  bold 20", "  ", color.red)
local forward           = create_textbox("Ubuntu nerd font  bold 20", "  ", color.blue)
local backward          = create_textbox("Ubuntu nerd font  bold 20", "  ", color.blue)

local stopwatch_buttons = {
	play_pause = create_button(play_pause),
	reset = create_button(reset),
	forward = create_button(forward),
	backward = create_button(backward)
}

local buttons           = wibox.widget {
	{
		{
			{
				stopwatch_buttons.backward,
				stopwatch_buttons.play_pause,
				stopwatch_buttons.reset,
				stopwatch_buttons.forward,
				layout = wibox.layout.fixed.horizontal
			},
			widget = wibox.container.place
		},
		widget = wibox.container.margin,
		margins = dpi(5)
	},
	shape = function(cr, width, height)
		gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, 7)
	end,
	widget = wibox.container.background,
	bg = color.background_lighter }

local stopwatch         = wibox.widget {
	{
		{
			{
				{
					add_timer,
					nil,
					set_timer_button,
					layout = wibox.layout.align.horizontal
				},
				widget = wibox.container.margin,
				top    = dpi(7),
				bottom = dpi(5),
				right  = dpi(5),
				left   = dpi(8),
			},
			widget = wibox.container.background,
			bg = color.background_lighter,
			shape = function(cr, width, height)
				gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, 7)
			end,
		},
		{

			{
				{
					time,
					widget = wibox.container.place
				},
				widget = wibox.container.margin,
				margins = dpi(10)
			},
			widget = wibox.container.background,
			bg = "#30364f",
			shape = function(cr, width, height)
				gears.shape.partially_rounded_rect(cr, width, height, false, false, false, false, 7)
			end,
		},
		buttons,
		layout = wibox.layout.fixed.vertical,
	},
	widget = wibox.container.margin,
	bottom = dpi(12),
	left = dpi(12),
	right = dpi(12),
	top = dpi(14),
}

local input_entered     = "-- : --"
local input_2           = "----"
local character_entered = 0
local final_input       = "00 : 00"

local function changeCharacterAtIndex(inputString, index, newCharacter)
	local leftPart = string.sub(inputString, 1, index - 1)
	local rightPart = string.sub(inputString, index + 1)

	local modifiedString = leftPart .. newCharacter .. rightPart

	return modifiedString
end

set_time = function()
	awful.prompt.run {
		textbox = wibox.widget.textbox(),
		exe_callback = function()
			final_input = input_entered
			local seconds = tonumber(string.sub(final_input, 6, 7))
			local minutes = tonumber(string.sub(final_input, 1, 2))
			if seconds > 60 then
				seconds = 60
			end
			final_input = string.format("%02d", minutes) .. " : " .. string.format("%02d", seconds)

			time.markup = '<span color="' ..
					color.green ..
					'" font="' ..
					"Ubuntu nerd font bold 66" ..
					'">' .. string.format("%02d", minutes) .. " : " .. string.format("%02d", seconds) .. '</span>'
			input_entered = "-- : --"
			input_2 = "----"
			character_entered = 0
			timer_isrunning = false
			play_pause.markup = '<span color="' ..
					color.yellow .. '" font="' .. "Ubuntu nerd font bold 20" .. '">' .. "  " .. '</span>'
		end,
		keypressed_callback = function(mod, key, cmd)
			if character_entered <= 4 then
				if key == "1" or key == "2" or key == "3" or key == "4" or key == "5" or key == "6" or key == "7" or key == "8" or key == "9" or key == "0" then
					character_entered = character_entered + 1
					input_2 = changeCharacterAtIndex(input_2, character_entered, key)
					input_entered = string.sub(input_2, 1, 2) .. " : " .. string.sub(input_2, 3, 4)
					time.markup = '<span color="' ..
							color.yellow .. '" font="' .. "Ubuntu nerd font bold 66" .. '">' .. input_entered .. '</span>'
				end
			end
		end
	}
end

local minute_input = tonumber(string.sub(final_input, 1, 2))
local second_input = tonumber(string.sub(final_input, 6, 7))
local total_time = minute_input * 60 + second_input

local timer_running = function()
	minute_input = tonumber(string.sub(final_input, 1, 2))
	second_input = tonumber(string.sub(final_input, 6, 7))
	total_time = minute_input * 60 + second_input
	total_time = total_time - 1
	if total_time >= 0 then
		local new_minute = math.floor(total_time / 60)
		local new_second = total_time % 60
		final_input = string.format("%02d", new_minute) .. " : " .. string.format("%02d", new_second)
		time.markup = '<span color="' ..
				color.green .. '" font="' .. "Ubuntu nerd font bold 66" .. '">' .. final_input .. '</span>'
	end

	if total_time == 1 then
		naughty.notify
		(
			{
				title = '<span color="' ..
						color.white .. '" font="Ubuntu Nerd Font Bold 14">󱎫 Timer Widget</span>',
				text = '<span color="' .. color.white .. '">The timer has ended! . Hope that was a productive time </span>',

				timeout = 5,
				icon = os.getenv("HOME") .. "/.config/awesome/popups/dashboard/home/todo_widgets/icons/clock2.png"
			}
		)
	end
end

local timer_main = gears.timer({
	timeout = 1,
	call_now = true,
	autostart = false,
	callback = timer_running,
})

set_timer_button:connect_signal("button::release", function()
	timer_main:stop()
	input_entered = "-- : --"
	character_entered = 0
	time.markup = '<span color="' ..
			color.yellow .. '" font="' .. "Ubuntu nerd font bold 66" .. '">' .. "-- : --" .. '</span>'
	set_time()
end)

stopwatch_buttons.forward:connect_signal("button::release", function()
	total_time = total_time + 30
	final_input = string.format("%02d", math.floor(total_time / 60)) .. " : " .. string.format("%02d", total_time % 60)
	time.markup = '<span color="' ..
			color.green .. '" font="' .. "Ubuntu nerd font bold 66" .. '">' .. final_input .. '</span>'
end)

stopwatch_buttons.backward:connect_signal("button::release", function()
	if total_time > 30 then
		total_time = total_time - 30
		final_input = string.format("%02d", math.floor(total_time / 60)) .. " : " .. string.format("%02d", total_time % 60)
		time.markup = '<span color="' ..
				color.green .. '" font="' .. "Ubuntu nerd font bold 66" .. '">' .. final_input .. '</span>'
	end
end)

stopwatch_buttons.reset:connect_signal("button::release", function()
	total_time = 0
	final_input = "00 : 00"
	time.markup = '<span color="' ..
			color.green .. '" font="' .. "Ubuntu nerd font bold 66" .. '">' .. final_input .. '</span>'
end)


timer_isrunning = false
stopwatch_buttons.play_pause:connect_signal("button::release", function()
	timer_isrunning = not timer_isrunning
	if timer_isrunning then
		timer_main:start()
		play_pause.markup = '<span color="' ..
				color.yellow .. '" font="' .. "Ubuntu nerd font bold 20" .. '">' .. "  " .. '</span>'
	else
		timer_main:stop()
		play_pause.markup = '<span color="' ..
				color.yellow .. '" font="' .. "Ubuntu nerd font bold 20" .. '">' .. "  " .. '</span>'
	end
end)

return stopwatch
