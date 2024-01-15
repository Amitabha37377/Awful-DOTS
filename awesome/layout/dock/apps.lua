local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local dpi = beautiful.xresources.apply_dpi
local helpers = require('helpers')
local color = require('themes.colors')
local user = require('user')

local create_btns = function(img, cmd)
	local app = cmd == nil and img or string.sub(cmd, 1, 7) == "flatpak" and img or cmd
	local launch = cmd == nil and img or cmd

	local imgbox = helpers.imagebox(user.icon_path .. img .. '.svg', 50, 50)
	imgbox.valign = 'center'
	imgbox.halign = 'center'

	local btn = wibox.widget {
		{
			imgbox,
			widget = wibox.container.margin,
			top    = dpi(3),
			bottom = dpi(1),
			left   = dpi(3),
			right  = dpi(3)
		},
		widget = wibox.container.background,
		bg = color.bg_dark,
		shape = helpers.rrect(5),
	}
	helpers.add_hover_effect(btn, color.bg_dim, color.bg_normal, color.bg_dark)

	local final_btn = helpers.margin(btn, 3, 3, 9, 0)
	final_btn.forced_width = dpi(70)
	final_btn:connect_signal("button::release", function(_, _, _, button)
		if button == 1 then
			awful.spawn(launch)
		end
	end)

	local indicator = wibox.widget {
		{
			widget = wibox.container.background,
			bg = color.bg_dark,
			shape = helpers.rrect(3),
			forced_width = dpi(3),
			forced_height = dpi(3)
		},
		layout = wibox.layout.flex.horizontal,
		forced_width = dpi(40),
		spacing = dpi(5)
	}

	local function update()
		local cnt = 1
		local col = color.bg_light
		indicator:reset()
		for _, c in ipairs(client.get()) do
			if string.lower(c.class or c.name):match(string.lower(tostring(app))) then
				if c == client.focus then
					col = color.lightblue
				elseif c.urgent then
					col = color.orange
				elseif c.minimized then
					col = color.purple
				elseif c.maximized then
					col = color.green
				else
					col = color.bg_light
				end
				indicator:insert(#indicator.children + 1,
					wibox.widget {
						widget = wibox.container.background,
						bg = col,
						shape = helpers.rrect(5),
						forced_width = dpi(3),
						forced_height = dpi(5)
					}
				)
			end
		end
	end

	client.connect_signal("request::manage", function()
		update()
	end)

	client.connect_signal("focus", function()
		update()
	end)

	client.connect_signal("request::manage", function()
		update()
	end)

	client.connect_signal("property::minimized", function()
		update()
	end)

	client.connect_signal("property::maximized", function()
		update()
	end)

	client.connect_signal("property::urgent", function()
		update()
	end)



	return wibox.widget {
		final_btn,
		helpers.margin(indicator, 15, 15, 0, 4),
		layout = wibox.layout.fixed.vertical,
	}
end

local function get_apps(progs)
	local apps = { layout = wibox.layout.fixed.horizontal }
	for i, p in ipairs(progs) do
		apps[i] = create_btns(p[1], p[2])
	end
	return apps
end


local dock = wibox.widget {
	get_apps(user.dock_elements),
	layout = wibox.layout.fixed.vertical
}



return dock
