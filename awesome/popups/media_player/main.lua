--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Custom Modules
local color = require("popups.color")
local bling = require("bling")

--Widgets
local Separator = wibox.widget.textbox("    ")
Separator.forced_height = dpi(500)
Separator.forced_width = dpi(400)

-------------------------------
--Media elements---------------
-------------------------------

--Album art
local art = wibox.widget {
	image = os.getenv("HOME") .. "/.config/awesome/popups/control_center/assets/music.svg",
	resize = true,
	forced_height = dpi(230),
	forced_width = dpi(375),
	widget = wibox.widget.imagebox,
	halign = "center"
}

--Player name
local name_widget = wibox.widget {
	markup = 'No players',
	align = 'left',
	valign = 'top',
	widget = wibox.widget.textbox,
	font = "CaskaydiaCove Nerd Font 14",
	forced_width = dpi(375),
	halign = "center"
}

--Title
local title_widget = wibox.widget {
	markup = '<span color="' ..
		color.blueish_white .. '" font="Ubuntu Nerd Font bold 16">' .. "Nothing Playing" .. '</span>',
	align = 'center',
	valign = 'top',
	widget = wibox.widget.textbox,
	font = "CaskaydiaCove Nerd Font 12",
	forced_width = dpi(375),
	forced_height = dpi(25),
	halign = "center"
}

--Channel name
local artist_widget = wibox.widget {
	markup = '<span color="' ..
		color.white .. '" font="Ubuntu Nerd Font 14">' .. "Unknown Artist" .. '</span>',
	align = 'center',
	valign = 'bottom',
	widget = wibox.widget.textbox,
	font = "CaskaydiaCove Nerd Font 10",
	forced_width = dpi(375),
	forced_height = dpi(20),
	halign = "center"
}

-- Get Song Info
local playerctl = bling.signal.playerctl.lib()
playerctl:connect_signal("metadata",
	function(_, title, artist, album_path, album, new, player_name)
		-- Set art widget
		art:set_image(gears.surface.load_uncached(album_path))

		-- Set player name, title and artist widgets
		name_widget:set_markup_silently(player_name)
		title_widget:set_markup_silently('<span color="' ..
			color.blueish_white .. '" font="Ubuntu Nerd Font 8 bold">' .. title .. '</span>')
		artist_widget:set_markup_silently('<span color="' ..
			color.white .. '" font="Ubuntu Nerd Font 11">' .. artist .. '</span>')
	end)


----------------------------
--Position Slider-----------
----------------------------

local media_slider = wibox.widget({
	widget = wibox.widget.slider,
	bar_shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 25)
	end,
	bar_height = dpi(15),
	bar_color = color.white,
	bar_active_color = color.red,
	handle_shape = gears.shape.circle,
	handle_color = color.red,
	handle_width = dpi(15),
	handle_border_width = 0,
	handle_border_color = "#4682b8",
	minimum = 0,
	maximum = 100,
	value = 0
})


local previous_value = 0
local internal_update = false

media_slider:connect_signal("property::value", function(_, new_value)
	if internal_update and new_value ~= previous_value then
		playerctl:set_position(new_value)
		previous_value = new_value
	end
end)


----Update position value
--local update_media_position = function()
--	awful.spawn.easy_async("playerctl position", function(stdout)
--		if stdout == "" then
--			local position = 0
--			media_slidevalr.value = position
--		else
--			local position = tonumber(stdout)
--			media_slider.value = position
--			previous_position = position
--		end
--	end)
--end

-- local media_slider_position_timer = gears.timer({
-- 	timeout = 1,
-- 	call_now = true,
-- 	autostart = true,
-- 	callback = update_media_position,
-- })


playerctl:connect_signal(
	"position", function(_, interval_sec, length_sec)
		internal_update = true
		previous_value = interval_sec
		media_slider.value = interval_sec
	end
)




-- local update_media_length = function()
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
-- end
-- awful.spawn.easy_async("timeout 0.4s playerctl -F metadata -f '{{mpris:length}}'", function(stdout)
-- 	if stdout == "" or nil then
-- 		local position = 100
-- 		media_slider.maximum = position
-- 	else
-- 		local position = tonumber(stdout)
-- 		if position ~= nil then
-- 			media_slider.maximum = position / 1000000 or nil
-- 		end
-- 	end
-- end)

-- local media_length_slider_timer = gears.timer({
-- 	timeout = 1,
-- 	call_now = true,
-- 	autostart = true,
-- 	callback = update_media_length,
-- })


----------------------------------
-- length and position text-------
----------------------------------

local length_text = wibox.widget {
	markup = '<span color="' ..
		color.blueish_white .. '" font="Ubuntu Nerd Font 11">' .. "00:00" .. '</span>',
	align = 'center',
	valign = 'top',
	widget = wibox.widget.textbox,
	font = "CaskaydiaCove Nerd Font 12",
	forced_width = dpi(100),
	forced_height = dpi(15),
	halign = "right"
}

local position_text = wibox.widget {
	markup = '<span color="' ..
		color.blueish_white .. '" font="Ubuntu Nerd Font 11">' .. "00:00" .. '</span>',
	align = 'center',
	valign = 'top',
	widget = wibox.widget.textbox,
	font = "CaskaydiaCove Nerd Font 12",
	forced_width = dpi(100),
	forced_height = dpi(15),
	halign = "left"
}



local update_length_text = function()
	awful.spawn.easy_async("timeout 0.4s playerctl -F metadata -f '{{mpris:length}}'", function(stdout)
		if stdout == "" then
			local text = '00:00'
			length_text:set_markup_silently('<span color="' ..
				color.blueish_white .. '" font="Ubuntu Nerd Font 11">' .. text .. '</span>')
		elseif stdout == nil then
			local length = 0
			local minutes = math.floor(length / 60)
			local formattedminutes = string.format("%02d", minutes)
			local seconds = math.floor(length % 60)
			local formattedseconds = string.format("%02d", seconds)

			length_text:set_markup_silently('<span color="' ..
				color.blueish_white ..
				'" font="Ubuntu Nerd Font 11">' .. formattedminutes .. ':' .. formattedseconds .. '</span>')
		else
			if tonumber(stdout) ~= nil then
				local length = tonumber(stdout) / 1000000
				local minutes = math.floor(length / 60)
				local formattedminutes = string.format("%02d", minutes)
				local seconds = math.floor(length % 60)
				local formattedseconds = string.format("%02d", seconds)

				length_text:set_markup_silently('<span color="' ..
					color.blueish_white ..
					'" font="Ubuntu Nerd Font 11">' .. formattedminutes .. ':' .. formattedseconds .. '</span>')
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

local update_position_text = function()
	awful.spawn.easy_async("playerctl position", function(stdout)
		if stdout == "" then
			local text = '00:00'
			position_text:set_markup_silently('<span color="' ..
				color.blueish_white .. '" font="Ubuntu Nerd Font 11">' .. text .. '</span>')
		else
			local length = tonumber(stdout)
			local minutes = math.floor(length / 60)
			local formattedminutes = string.format("%02d", minutes)
			local seconds = math.floor(length % 60)
			local formattedseconds = string.format("%02d", seconds)
			position_text:set_markup_silently('<span color="' ..
				color.blueish_white ..
				'" font="Ubuntu Nerd Font 11">' .. formattedminutes .. ':' .. formattedseconds .. '</span>')
		end
	end)
end

local update_position_text_timer = gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = update_position_text,
})


local media_container = {
	{
		media_slider,
		widget = wibox.container.margin,
		top = dpi(1),
		bottom = dpi(0),
		-- right = dpi(15),
		-- left = dpi(5),
		forced_width = dpi(370),
		forced_height = dpi(40)
	},
	{
		{
			{
				position_text,
				widget = wibox.container.margin,
				right = dpi(85)
			},
			{
				length_text,
				widget = wibox.container.margin,
				left = dpi(85)
			},
			layout = wibox.layout.fixed.horizontal
		},
		widget = wibox.container.margin,
		top = dpi(2),
	},
	layout = wibox.layout.fixed.vertical,
}

---------------------------------
--Buttons------------------------
---------------------------------

--Play pause button
local button = wibox.widget {
	image = os.getenv("HOME") .. "/.config/awesome/popups/media_player/assets/pause.png",
	resize = true,
	forced_height = dpi(40),
	forced_width = dpi(40),
	widget = wibox.widget.imagebox,
	valign = "center",
	halign = "center"
}

--Play pause button functionality
local is_playing = false

button:buttons(gears.table.join(
	awful.button({}, 1, function()
		playerctl:play_pause()
		is_playing = not is_playing
		if is_playing then
			if title_widget.markup == '<span color="' .. color.blueish_white .. '" font="Ubuntu Nerd Font bold 12">' .. "Nothing Playing" .. '</span>' then
				button:set_image(os.getenv("HOME") .. "/.config/awesome/popups/media_player/assets/pause.png")
			else
				button:set_image(os.getenv("HOME") .. "/.config/awesome/popups/media_player/assets/play2.png")
			end
		else
			if title_widget.markup == '<span color="' .. color.blueish_white .. '" font="Ubuntu Nerd Font bold 12">' .. "Nothing Playing" .. '</span>' then
				button:set_image(os.getenv("HOME") .. "/.config/awesome/popups/media_player/assets/pause.png")
			else
				button:set_image(os.getenv("HOME") .. "/.config/awesome/popups/media_player/assets/pause.png")
			end
		end
	end)
))

--Next & previous button
local next = wibox.widget {
	image = os.getenv("HOME") .. "/.config/awesome/popups/media_player/assets/next-button.png",
	resize = true,
	forced_height = dpi(40),
	forced_width = dpi(40),
	widget = wibox.widget.imagebox,
	valign = "center",
	halign = "center"
}

next:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		awful.spawn.with_shell("playerctl next")
	end
end)


local previous = wibox.widget {
	image = os.getenv("HOME") .. "/.config/awesome/popups/media_player/assets/previous.png",
	resize = true,
	forced_height = dpi(40),
	forced_width = dpi(40),
	widget = wibox.widget.imagebox,
	valign = "center",
	halign = "center"
}

previous:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		awful.spawn.with_shell("playerctl previous")
	end
end)


-- 15s backward forward
local forward = wibox.widget {
	image = os.getenv("HOME") .. "/.config/awesome/popups/media_player/assets/15sforward.png",
	resize = true,
	forced_height = dpi(45),
	forced_width = dpi(45),
	widget = wibox.widget.imagebox,
	valign = "center",
	halign = "center"
}

forward:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		awful.spawn.with_shell("playerctl position 15+")
	end
end)



local backward = wibox.widget {
	image = os.getenv("HOME") .. "/.config/awesome/popups/media_player/assets/15sbackward.png",
	resize = true,
	forced_height = dpi(45),
	forced_width = dpi(45),
	widget = wibox.widget.imagebox,
	valign = "center",
	halign = "center"
}

backward:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		awful.spawn.with_shell("playerctl position 15-")
	end
end)


-----------------------------------------------
--Main Wibox-----------------------------------
-----------------------------------------------

local media = awful.popup {
	screen = s,
	widget = wibox.container.background,
	ontop = true,
	bg = "#00000000",
	visible = false,
	-- maximum_width = 200,
	placement = function(c)
		awful.placement.top_right(c,
			{ margins = { top = dpi(43), bottom = dpi(8), left = dpi(8), right = dpi(8) } })
	end,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 0)
	end,
	opacity = 1,
	border_width = dpi(0),
	border_color = color.blue
}

media:setup { {
	{
		{
			{
				{
					art,
					widget = wibox.container.margin,
					bottom = dpi(5)
				},
				{
					title_widget,
					widget = wibox.container.margin,
					bottom = dpi(7)
				},
				artist_widget,
				{
					media_container,
					widget = wibox.container.margin,
					top = dpi(10),
					bottom = dpi(35)
				},
				{
					{
						backward,
						widget = wibox.container.margin,
						left = dpi(30),
						right = dpi(12)
					},
					{
						previous,
						widget = wibox.container.margin,
						left = dpi(12),
						right = dpi(12)
					},
					{
						button,
						widget = wibox.container.margin,
						left = dpi(12),
						right = dpi(12)
					},
					{
						next,
						widget = wibox.container.margin,
						left = dpi(12),
						right = dpi(12)
					},
					{
						forward,
						widget = wibox.container.margin,
						left = dpi(12),
						right = dpi(12)
					},
					layout = wibox.layout.fixed.horizontal,
				},
				layout = wibox.layout.fixed.vertical
			},
			widget = wibox.container.margin,
			top = dpi(25),
			left = dpi(25),
			right = dpi(25),
		},
		Separator,
		layout = wibox.layout.stack
	},
	layout = wibox.layout.fixed.vertical,
	widget = wibox.widget.margin,
	top = dpi(25),
	left = dpi(25),
	right = dpi(25),
},
	widget = wibox.container.background,
	bg = color.background_dark,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 10)
	end,

}

return media
