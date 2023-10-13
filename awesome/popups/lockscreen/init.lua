--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Custom Modules
local color = require("popups.color")
local user = require("popups.user_profile")

local Separator = wibox.widget.textbox("    ")
Separator.forced_height = dpi(1080)
Separator.forced_width = dpi(1920)

------------------------------
--Widgets---------------------
------------------------------

--Right-----------------------
local header_text = wibox.widget {
	markup = '<span color="' ..
			color.red .. '" font="Ubuntu Nerd Font Bold 30">' .. 'SCREEN LOCKED!' .. '</span>',
	widget = wibox.widget.textbox,
	halign = "center",
	valign = "top",
}


local header = wibox.widget {
	header_text,
	widget = wibox.container.margin,
	top = dpi(70),
	bottom = dpi(50),
}

local footer_text = wibox.widget {
	markup = '<span color="' ..
			color.blue .. '" font="Ubuntu Nerd Font Bold 22">' .. ' Enter Password' .. '</span>',
	widget = wibox.widget.textbox,
	halign = "center",
	valign = "top",
}

local footer = wibox.widget {
	footer_text,
	widget = wibox.container.margin,
	top = dpi(60),
	bottom = dpi(30),
}

local create_textbox = function(text, fg)
	local text_box = wibox.widget {
		markup = '<span color="' ..
				fg .. '" font="Ubuntu Nerd Font Bold 18">' .. text .. '</span>',
		halign = "left",
		valign = "center",
		widget = wibox.widget.textbox
	}
	return text_box
end

local text1 = create_textbox("  " .. user.name, color.yellow)
local text2 = create_textbox("󰌆  ", color.green)

local create_text_container = function(textbox)
	local text_container = wibox.widget { {
		textbox,
		widget = wibox.container.margin,
		top = dpi(12),
		bottom = dpi(12),
		left = dpi(20)
	},
		widget = wibox.container.background,
		bg = "#36496e",
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 15)
		end,
		border_width = dpi(3),
		border_color = "#36495e"
	}
	return text_container
end

local text_1 = create_text_container(text1)
local text_2 = create_text_container(text2)

local text_cont1 = wibox.widget {
	text_1,
	widget = wibox.container.margin,
	top = dpi(10),
	bottom = dpi(10),
	left = dpi(25),
	right = dpi(25),
}

local text_cont2 = wibox.widget {
	text_2,
	widget = wibox.container.margin,
	top = dpi(10),
	bottom = dpi(10),
	left = dpi(25),
	right = dpi(25),
}

local right = wibox.widget {
	header,
	text_cont1,
	text_cont2,
	footer,
	layout = wibox.layout.fixed.vertical
}

--Left--------------------------
local image = wibox.widget {
	widget = wibox.widget.imagebox,
	image = os.getenv("HOME") .. "/.config/awesome/popups/lockscreen/assets/Guard.jpg",
	resize = true,
	opacity = 1,
	forced_width = dpi(480),
	forced_height = dpi(480)
}

local left_img = wibox.widget {
	image,
	widget = wibox.container.background,
	bg = color.background_lighter,
	shape = function(cr, width, height)
		gears.shape.partially_rounded_rect(cr, width, height, true, false, false, true, 8)
	end,
}

local sep = wibox.widget.textbox("    ")
sep.forced_height = dpi(480)
sep.forced_width = dpi(480)

----------------------------------
---Box----------------------------
----------------------------------
local box = wibox.widget {
	{
		left_img,
		{
			{
				sep,
				right,
				widget = wibox.layout.stack
			},
			widget = wibox.container.background,
			bg = color.background_lighter2,
			shape = function(cr, width, height)
				gears.shape.partially_rounded_rect(cr, width, height, false, true, true, false, 8)
			end,
		},
		layout = wibox.layout.fixed.horizontal
	},
	widget = wibox.container.place
}

---------------------------------
--Clock--------------------------
---------------------------------
local clock = wibox.widget.textclock(
	'<span color="' .. color.cyan .. '" font="Ubuntu Nerd Font Bold 75">%H:%M</span>', 10)

local date = wibox.widget.textclock(
	'<span color="' .. color.blue .. '" font="Ubuntu Nerd Font Bold 35">%d %B, %A</span>', 10)

----------------------------------
--Main lockscreen window----------
----------------------------------
local lockscreen = awful.popup {
	screen = s,
	widget = wibox.container.background,
	ontop = true,
	bg = "#00000000",
	visible = false,
	placement = function(c)
		awful.placement.centered(c,
			{ margins = { top = dpi(0), bottom = dpi(0), left = dpi(0), right = dpi(0) } })
	end,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 0)
	end,
	opacity = 1,
	forced_height = dpi(1080),
	forced_width = dpi(1920),
}

lockscreen:setup {
	{
		Separator,
		{
			{
				{
					{
						clock,
						widget = wibox.container.place
					},
					{
						date,
						widget = wibox.container.place
					},
					layout = wibox.layout.fixed.vertical
				},
				widget = wibox.container.margin,
				top = dpi(50),
				bottom = dpi(100)
			},
			{
				box,
				widget = wibox.container.place
			},
			layout = wibox.layout.fixed.vertical
		},
		layout = wibox.layout.stack
	},
	widget = wibox.container.background,
	bg = "#242846",
}

------------------------------------
--Functionality---------------------
------------------------------------

local characters_entered = 0

local correct_passwd = function()
	footer_text.markup  = '<span color="' ..
			color.green .. '" font="Ubuntu Nerd Font Bold 22">' .. ' Correct Password!' .. '</span>'
	text_2.border_color = color.magenta
	header_text.markup  = '<span color="' ..
			color.green .. '" font="Ubuntu Nerd Font Bold 30">' .. 'SCREEN UNLOCKED!' .. '</span>'
	awful.spawn.easy_async_with_shell("sleep 0.5", function()
		lockscreen.visible = false
	end)
end

local incorrect_passwd = function()
	text_2.border_color = color.red
	footer_text:set_markup_silently('<span color="' ..
		color.red .. '" font="Ubuntu Nerd Font Bold 22">' .. ' Wrong Password' .. '</span>')
	text2.markup = '<span color="' ..
			color.green ..
			'" font="Ubuntu Nerd Font Bold 18">' .. '󰌆  ' .. '</span>'
	characters_entered = 0
end

local reset = function()
	footer_text.markup = '<span color="' ..
			color.blue .. '" font="Ubuntu Nerd Font Bold 22">' .. ' Enter Password!' .. '</span>'
	text_2.border_color = "#36495e"
	header_text.markup = '<span color="' ..
			color.red .. '" font="Ubuntu Nerd Font Bold 30">' .. 'SCREEN LOCKED!' .. '</span>'
	text2.markup = '<span color="' ..
			color.green ..
			'" font="Ubuntu Nerd Font Bold 18">' .. '󰌆  ' .. '</span>'
	characters_entered = 0
end


local function passwd()
	awful.prompt.run {
		textbox             = wibox.widget.textbox(),

		hooks               = {
			{ {}, 'Escape', function(_)
				reset()
				passwd()
			end
			}
		},

		exe_callback        = function(input)
			if input == user.fallback_password then
				correct_passwd()
			else
				incorrect_passwd()
				passwd()
			end
		end,

		keypressed_callback = function(mod, key, cmd)
			if #key == 1 then
				characters_entered = characters_entered + 1
				text2.markup = '<span color="' .. color.green ..
						'" font="Ubuntu Nerd Font Bold 18">' .. '󰌆  ' .. '</span>' .. '<span color="' .. color.magenta ..
						'" font="Ubuntu Nerd Font Bold 14">' .. string.rep('', characters_entered) .. '</span>'
			elseif key == "BackSpace" then
				if characters_entered >= 1 then
					characters_entered = characters_entered - 1
					text2.markup = '<span color="' .. color.green ..
							'" font="Ubuntu Nerd Font Bold 18">' .. '󰌆  ' .. '</span>' .. '<span color="' .. color.magenta ..
							'" font="Ubuntu Nerd Font Bold 14">' .. string.rep('', characters_entered) .. '</span>'
				else
					characters_entered = 0
					text2.markup = '<span color="' ..
							color.green ..
							'" font="Ubuntu Nerd Font Bold 18">' .. '󰌆  ' .. '</span>'
				end
			end
		end,
	}
end


awesome.connect_signal("screen::lock", function()
	lockscreen.visible = not lockscreen.visible
	if lockscreen.visible then
		reset()
		passwd()
	end
end)

-- if user.sessionlock then
-- 	lockscreen()
-- end

return lockscreen
