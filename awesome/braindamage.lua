local awful = require 'awful'
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local dpi = beautiful.xresources.apply_dpi
local helpers = require 'helpers'
local colors = require 'themes.colors'
local rubato = require 'modules.rubato'

local ease = require 'damage2'

local txt = wibox.widget.textbox("  ")
txt.forced_height = dpi(30)
txt.forced_width = dpi(30)


local box1 = awful.popup {
	width = dpi(50),
	screen = s,
	height = dpi(1080),
	bg = "#000000",
	widget = wibox.container.background,
	x = dpi(200),
	y = dpi(400),
	shape = helpers.rrect(0)
}

local box2 = awful.popup {
	width = dpi(50),
	screen = s,
	height = dpi(1080),
	bg = "#000000",
	widget = wibox.container.background,
	x = dpi(200),
	y = dpi(500),
	shape = helpers.rrect(0)
}

box1:setup({
	txt,
	widget = wibox.container.background,
	bg = colors.blue
})

box2:setup({
	txt,
	widget = wibox.container.background,
	bg = colors.green
})


awesome.connect_signal("brain::damage", function()
	-- local one = {
	-- 	F = 1 / 2,
	-- 	easing = ease({
	-- 		{
	-- 			{ 0,     0 },
	-- 			{ 0.05,  0 },
	-- 			{ 0.133, 0.06 },
	-- 			{ 0.166, 0.4 },
	-- 		},
	-- 		{
	-- 			{ 0.166, 0.4 },
	-- 			{ 0.208, 0.82 },
	-- 			{ 0.25,  1 },
	-- 			{ 1,     1 },
	-- 		},
	-- 	}
	-- 	)
	-- }

	-- local easeoutExpo = {
	-- 	F = 3.250000,
	-- 	easing = ease({
	-- 		{
	-- 			{ 0,     0 },
	-- 			{ 0.05,  0 },
	-- 			{ 0.133, 0.06 },
	-- 			{ 0.166, 0.4 },
	-- 		},
	-- 		{
	-- 			{ 0.166, 0.4 },
	-- 			{ 0.208, 0.82 },
	-- 			{ 0.25,  1 },
	-- 			{ 1,     1 },
	-- 		},
	-- 	}
	-- 	)
	-- }

	local easeing = {
		F = 1.012657,
		easing = function(x)
			local y = 1.012657 + (-0.003839478 - 1.012657) / (1 + (x / math.pow(0.1753202, 9.13296)))
			return y
		end
	}

	local eas2 = {
		easing = function(t)
			return t
		end,
		F = 0.5
	}

	local timed = rubato.timed {
		duration = 1,
		-- intro = 1 / 2,
		override_dt = true,
		easing = easeing,
		subscribed = function(pos)
			box1.x = pos + 200
		end
	}
	timed.target = 800

	local timed2 = rubato.timed {
		duration = 1,
		-- intro = 1 / 9,
		override_dt = true,
		easing = rubato.linear,
		subscribed = function(pos)
			box2.x = pos + 200
		end
	}
	timed2.target = 800
end)
