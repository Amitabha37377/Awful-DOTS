local awful             = require 'awful'
local wibox             = require 'wibox'
local gears             = require 'gears'
local beautiful         = require 'beautiful'
local dpi               = beautiful.xresources.apply_dpi

local color             = require 'themes.colors'
local helpers           = require 'helpers'

--Textbox------

local time              = helpers.textbox(color.blue, "Ubuntu Nerd Font bold 66", "00 : 00")
local add_timer         = helpers.textbox(color.lightblue, "Ubuntu Nerd Font bold 16", "  Add timer")
local set_timer_button  = helpers.textbox(color.purple, "Ubuntu Nerd Font bold 20", "  󱎫  ")
local play_pause        = helpers.textbox(color.orange, "Ubuntu nerd font  bold 20", "  ")
local reset             = helpers.textbox(color.red, "Ubuntu nerd font  bold 20", "  ")
local forward           = helpers.textbox(color.blue, "Ubuntu nerd font  bold 20", "  ")
local backward          = helpers.textbox(color.blue, "Ubuntu nerd font  bold 20", "  ")

--Buttons------

local create_button     = function(icon)
	local button_bg = wibox.widget {
		{
			icon,
			widget = wibox.container.margin,
			margins = dpi(3)
		},
		widget = wibox.container.background,
		bg = color.bg_normal,
		shape = helpers.rrect(4)
	}

	local button = helpers.margin(button_bg, 22, 22, 2, 2)
	helpers.add_hover_effect(button_bg, color.bg_light, color.mid_dark, color.bg_normal)

	return button
end

local stopwatch_buttons = {
	play_pause = create_button(play_pause),
	reset = create_button(reset),
	forward = create_button(forward),
	backward = create_button(backward)
}

--------------------------
--Main widget-------------
--------------------------
local timer             = wibox.widget {
	{
		{
			helpers.margin({
				add_timer,
				nil,
				set_timer_button,
				layout = wibox.layout.align.horizontal,
			}, 15, 15, 10, 0),
			widget = wibox.container.background,
			bg = color.bg_normal,
		},
		{
			{
				helpers.margin({
					time,
					widget = wibox.container.place
				}, 20, 20, 10, 10),
				widget = wibox.container.background,
				bg = color.bg_dim,
				border_width = dpi(10),
				border_color = color.bg_normal,
				shape = helpers.rrect(10)
			},
			widget = wibox.container.background,
			bg = color.bg_normal
		},
		{
			helpers.margin({
				{
					stopwatch_buttons.backward,
					stopwatch_buttons.play_pause,
					stopwatch_buttons.reset,
					stopwatch_buttons.forward,
					layout = wibox.layout.fixed.horizontal
				},
				widget = wibox.container.place
			}, 20, 20, -5, 5),
			widget = wibox.container.background,
			bg = color.bg_normal
		},
		layout = wibox.layout.fixed.vertical
	},
	widget = wibox.container.background,
	shape = helpers.rrect(15),
	border_width = dpi(0),
	border_color = color.bg_normal
}

-----------------------
--Functionality--------
-----------------------
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
					color.blue ..
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
				color.blue .. '" font="' .. "Ubuntu nerd font bold 66" .. '">' .. final_input .. '</span>'
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
			color.blue .. '" font="' .. "Ubuntu nerd font bold 66" .. '">' .. final_input .. '</span>'
end)

stopwatch_buttons.backward:connect_signal("button::release", function()
	if total_time > 30 then
		total_time = total_time - 30
		final_input = string.format("%02d", math.floor(total_time / 60)) .. " : " .. string.format("%02d", total_time % 60)
		time.markup = '<span color="' ..
				color.blue .. '" font="' .. "Ubuntu nerd font bold 66" .. '">' .. final_input .. '</span>'
	end
end)

stopwatch_buttons.reset:connect_signal("button::release", function()
	total_time = 0
	final_input = "00 : 00"
	time.markup = '<span color="' ..
			color.blue .. '" font="' .. "Ubuntu nerd font bold 66" .. '">' .. final_input .. '</span>'
end)


timer_isrunning = false
stopwatch_buttons.play_pause:connect_signal("button::release", function()
	timer_isrunning = not timer_isrunning
	if timer_isrunning then
		timer_main:start()
		play_pause.markup = '<span color="' ..
				color.orange .. '" font="' .. "Ubuntu nerd font bold 20" .. '">' .. "  " .. '</span>'
	else
		timer_main:stop()
		play_pause.markup = '<span color="' ..
				color.orange .. '" font="' .. "Ubuntu nerd font bold 20" .. '">' .. "  " .. '</span>'
	end
end)



return helpers.margin(timer, 10, 10, 10, 10)
