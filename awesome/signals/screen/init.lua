local awful = require 'awful'
local beautiful = require 'beautiful'
local wibox = require 'wibox'

local vars = require 'config.vars'
-- local widgets = require 'widgets'

-- local user = require("user")

-- screen.connect_signal('request::wallpaper', function(s)
-- 	awful.wallpaper {
-- 		screen = s,
-- 		widget = {
-- 			{
-- 				image     = beautiful.wallpaper,
-- 				upscale   = true,
-- 				downscale = true,
-- 				widget    = wibox.widget.imagebox,
-- 			},
-- 			valign = 'center',
-- 			halign = 'center',
-- 			tiled = false,
-- 			widget = wibox.container.tile,
-- 		}

-- 	}
-- end)

screen.connect_signal('request::desktop_decoration', function(s)
	awful.tag(vars.tags, s, awful.layout.layouts[1])
end)
