local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
local gears = require('gears')

local dpi = beautiful.xresources.apply_dpi
local helpers = require('helpers')
local color = require("themes.colors")
local user = require("user")

local bling = require("modules.bling")

-------------------------
--Components-------------
-------------------------

-- Album art
local art = helpers.imagebox(os.getenv("HOME") .. "/.config/awesome/assets/control_center/music.svg", 80, 120)
art.halign = 'center'
art.valign = 'center'

-- Title
local title_widget = helpers.textbox(color.lightblue, "Ubuntu nerd font bold 16", "Nothing playing")
title_widget.forced_width = dpi(250)
title_widget.forced_height = dpi(30)

--Artist
local artist_widget = helpers.textbox(color.mid_light, "Ubuntu nerd font 14", "Unknown artist")
artist_widget.forced_width = dpi(250)
artist_widget.forced_height = dpi(30)

-- Update image, title, channel
local playerctl = bling.signal.playerctl.lib()
playerctl:connect_signal("metadata",
	function(_, title, artist, album_path, album, new, player_name)
		art:set_image(gears.surface.load_uncached(album_path))
		title_widget:set_markup_silently(helpers.mtext(color.lightblue, "ubuntu nerd font 16 bold", title))
		artist_widget:set_markup_silently(helpers.mtext(color.mid_light, "Ubuntu nerd font 14", artist))
	end)

-----------------------------
--Position Slider------------
-----------------------------
local media_slider = wibox.widget {
	widget = wibox.widget.slider,
	bar_shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 25)
	end,
	bar_height = dpi(8),
	bar_color = color.mid_dark,
	bar_active_color = color.blue,
	handle_shape = gears.shape.circle,
	handle_color = color.lightblue,
	handle_width = dpi(15),
	handle_border_width = 0,
	handle_border_color = "#4682b8",
	minimum = 0,
	maximum = 100,
	value = 69
}

--Update slider value
local previous_value = 0
local internal_update = false

media_slider:connect_signal("property::value", function(_, new_value)
	if internal_update and new_value ~= previous_value then
		playerctl:set_position(new_value)
		previous_value = new_value
	end
end)

playerctl:connect_signal(
	"position", function(_, interval_sec, length_sec)
		internal_update = true
		previous_value = interval_sec
		media_slider.value = interval_sec
	end
)

--Update maximum length
awful.spawn.with_line_callback("playerctl -F metadata -f '{{mpris:length}}'", {
	stdout = function(line)
		if line == " " then
			local position = 100
			media_slider.maximum = position
		else
			local position = tonumber(line)
			if position ~= nil then
				media_slider.maximum = position / 1000000 or nil
			end
		end
	end
})

-----------------------------
--Position & length text-----
-----------------------------
local length_text = wibox.widget {
	markup = helpers.mtext(color.mid_light, "Ubuntu nerd font bold 11", "00:00"),
	valign = 'top',
	widget = wibox.widget.textbox,
	forced_height = dpi(15),
	halign = "left"
}

local position_text = wibox.widget {
	markup = helpers.mtext(color.mid_light, "Ubuntu nerd font bold 11", "00:00"),
	align = 'center',
	valign = 'top',
	widget = wibox.widget.textbox,
	forced_height = dpi(15),
	halign = "left"
}

--Update media length---
local update_length_text = function()
	awful.spawn.easy_async("timeout 0.4s playerctl -F metadata -f '{{mpris:length}}'", function(stdout)
		if stdout == "" then
			local text = '00:00'
			length_text:set_markup_silently(helpers.mtext(color.mid_light, "Ubuntu nerd font bold 11", text))
		elseif stdout == nil then
			local length = 0
			local minutes = math.floor(length / 60)
			local formattedminutes = string.format("%02d", minutes)
			local seconds = math.floor(length % 60)
			local formattedseconds = string.format("%02d", seconds)
			length_text:set_markup_silently(
				helpers.mtext(color.mid_light, "Ubuntu nerd font bold 11", formattedminutes .. ':' .. formattedseconds)
			)
		else
			if tonumber(stdout) ~= nil then
				local length = tonumber(stdout) / 1000000
				local minutes = math.floor(length / 60)
				local formattedminutes = string.format("%02d", minutes)
				local seconds = math.floor(length % 60)
				local formattedseconds = string.format("%02d", seconds)
				length_text:set_markup_silently(
					helpers.mtext(color.mid_light, "Ubuntu nerd font bold 11", formattedminutes .. ':' .. formattedseconds)
				)
			end
		end
	end)
end

local update_length_text_timer = gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = update_length_text,
})

--Update media position
local update_position_text = function()
	awful.spawn.easy_async("playerctl position", function(stdout)
		if stdout == "" then
			local text = '00:00'
			position_text:set_markup_silently(helpers.mtext(color.mid_light, "Ubuntu nerd font bold 11", text))
		else
			local length = tonumber(stdout)
			local minutes = math.floor(length / 60)
			local formattedminutes = string.format("%02d", minutes)
			local seconds = math.floor(length % 60)
			local formattedseconds = string.format("%02d", seconds)
			position_text:set_markup_silently(
				helpers.mtext(color.mid_light, "Ubuntu nerd font bold 11", formattedminutes .. ':' .. formattedseconds)
			)
		end
	end)
end

local update_position_text_timer = gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = update_position_text,
})

------------------------------
--Buttons---------------------
------------------------------

local play_pause = helpers.textbox(color.blue, "Ubuntu nerd font bold 17", "")
local forward = helpers.textbox(color.purple, "Ubuntu nerd font bold 17", "")
local backward = helpers.textbox(color.purple, "Ubuntu nerd font bold 17", "")
local f15 = helpers.textbox(color.green, "Ubuntu nerd font bold 17", "󱤺")
local b15 = helpers.textbox(color.green, "Ubuntu nerd font bold 17", "󱥆")

local create_container = function(wgt)
	local btn = helpers.margin(
		wibox.widget {
			wgt,
			widget = wibox.container.place
		},
		8, 8, 8, 8
	)

	btn.forced_height = dpi(45)
	btn.forced_width = dpi(45)

	local container = wibox.widget {
		btn,
		widget = wibox.container.background,
		bg = color.bg_dark,
		border_width = 3,
		border_color = color.bg_dark .. "80",
		shape = helpers.rrect(40)
	}

	return helpers.margin(container, 8, 8, 0, 0)
end

local play_pause_btn = create_container(play_pause)
local forward_btn = create_container(forward)
local backward_btn = create_container(backward)
local f15_btn = create_container(f15)
local b15_btn = create_container(b15)

--Button functionality
local is_playing = true
play_pause_btn:connect_signal("button::release", function()
	is_playing = not is_playing
	if is_playing then
		play_pause.markup = helpers.mtext(color.blue, "Ubuntu nerd font bold 17", '')
		awful.spawn('playerctl play')
	else
		play_pause.markup = helpers.mtext(color.blue, "Ubuntu nerd font bold 17", '')
		awful.spawn('playerctl pause')
	end
end)

forward_btn:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		awful.spawn.with_shell("playerctl next")
	end
end)

backward_btn:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		awful.spawn.with_shell("playerctl previous")
	end
end)

f15_btn:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		awful.spawn.with_shell("playerctl position 15+")
	end
end)

b15_btn:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		awful.spawn.with_shell("playerctl position 15-")
	end
end)



------------------------------
--Main widget-----------------
------------------------------
local main = helpers.margin(
	wibox.widget {
		{
			{
				helpers.margin(
					{
						helpers.margin(art, 0, 20, 0, 0),
						{
							{
								helpers.margin(title_widget, 0, 0, 0, 0),
								helpers.margin(artist_widget, 0, 0, 0, 0),
								layout = wibox.layout.fixed.vertical
							},
							widget = wibox.container.place
						},
						layout = wibox.layout.fixed.horizontal
					},
					15, 15, 10, 10),
				{
					{
						{
							media_slider,
							widget = wibox.container.margin,
							forced_height = dpi(20)
						},
						{
							{
								position_text,
								nil,
								length_text,
								layout = wibox.layout.align.horizontal
							},
							widget = wibox.container.margin,
							left = dpi(10),
							right = dpi(10),
							top = dpi(2)
						},
						layout = wibox.layout.fixed.vertical
					},

					widget = wibox.container.margin,
					top = 0,
					bottom = dpi(15),
					left = dpi(15),
					right = dpi(15),
					forced_width = dpi(430),
				},
				layout = wibox.layout.fixed.vertical,
			},
			widget = wibox.container.background,
			bg = color.bg_normal,
			shape = helpers.part_rrect(true, true, false, false, 8)
		},
		{
			{
				{
					{
						b15_btn,
						backward_btn,
						play_pause_btn,
						forward_btn,
						f15_btn,
						layout = wibox.layout.fixed.horizontal,
					},
					widget = wibox.container.place
				},
				widget = wibox.container.margin,
				top = dpi(5),
				bottom = dpi(5)
			},
			widget = wibox.container.background,
			bg = color.bg_dim,
			shape = helpers.part_rrect(false, false, true, true, 8)
		},
		layout = wibox.layout.fixed.vertical
	},
	25, 25, 10, 30
)


return main
