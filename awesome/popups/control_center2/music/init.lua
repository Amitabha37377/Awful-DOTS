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
				layout = wibox.layout.fixed.vertical,
			},
			widget = wibox.container.background,
			bg = color.bg_normal,
			shape = helpers.rrect(8)
		},

		layout = wibox.layout.fixed.vertical
	},
	25, 25, 10, 30
)


return main
