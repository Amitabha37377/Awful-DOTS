-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Wibox handling library
local wibox = require("wibox")

-- Custom Local Library: Common Functional Decoration
local deco = {
	wallpaper = require("deco.wallpaper"),
	taglist = require("deco.taglist"),
	tasklist = require("deco.tasklist"),
}

local taglist_buttons = deco.taglist()
local tasklist_buttons = deco.tasklist()

local _M = {}

--Spacer
local separator = wibox.widget.textbox("     ")

local battery_widget = require("deco.battery")
local calendar_widget = require("deco.calendar")
local batteryarc_widget = require("deco.batteryarc")
local logout_menu_widget = require("deco.logout-menu")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Wibar
--textclock widget
mytextclock = wibox.widget.textclock('<span color="#dddddd" font="Roboto Bold 13"> %a %b %d, %H:%M </span>', 10)

--calendar-widget
local cw = calendar_widget({
	theme = "outrun",
	placement = "top_center",
	start_sunday = true,
	radius = 8,
	previous_month_button = 1,
	next_month_button = 3,
})
mytextclock:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		cw.toggle()
	end
end)

--Tasklist Icons Popupbox
---------------------------------------------------
-- Define button widget
local button = awful.widget.button({
	image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/64x64/apps/appimagekit-dockstation.svg",
	widget = wibox.widget.imagebox,
})

-- Define popup widget
local popup = awful.popup({
	widget = awful.widget.tasklist({
		screen = screen[1],
		filter = awful.widget.tasklist.filter.allscreen,
		buttons = tasklist_buttons,
		margins = {
			top = 10,
			bottom = 10,
			left = 10,
			right = 10,
		},
		style = {
			shape = gears.shape.rounded_rect,
		},
		layout = {
			margins = 5,
			spacing = 5,
			forced_num_rows = 2,
			layout = wibox.layout.grid.horizontal,
		},
		widget_template = {
			{
				{
					id = "clienticon",
					widget = awful.widget.clienticon,
					margins = 4,
					resize = false,
				},
				margins = 4,
				widget = wibox.container.margin,
			},
			id = "background_role",
			forced_width = 58,
			forced_height = 58,
			widget = wibox.container.background,
			create_callback = function(self, c, index, objects) --luacheck: no unused
				self:get_children_by_id("clienticon")[1].client = c
			end,
		},
	}),
	bg = "#00000099",
	border_color = "#00000099",
	border_width = 10,
	ontop = true,
	-- placement    = awful.placement.bottom_left + awful.placement.no_offscreen,
	placement = function(c)
		local screen_geometry = awful.screen.focused().geometry
		return awful.placement.bottom_left(c, { margins = { left = 56, bottom = 10 } })
	end,
	geometry = { x = 10, y = -10 },
	shape = gears.shape.rounded_rect,
	visible = false,
})

-- Define button callback function
button:connect_signal("button::release", function()
	popup.visible = not popup.visible
end)
---------------------------------------------------
--Control Center Widget
----------------------------------------------------

-- Define button widget
local button_control = awful.widget.button({
	image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/applications-system.png",
	widget = wibox.widget.imagebox,
})

local volume_slider = wibox.widget({
	widget = wibox.widget.slider,
	bar_shape = gears.shape.rounded_rect,
	bar_height = 10,
	bar_color = "#b7b2f1",
	handle_shape = gears.shape.circle,
	handle_color = "#ffffff",
	handle_width = 30,
	handle_border_width = 1,
	handle_border_color = "#aaaaaa",
	minimum = 0,
	maximum = 100,
	value = 50,
})

-- Define a timer to update the volume slider value every second
local update_volume_slider = function()
	awful.spawn.easy_async("amixer sget Master", function(stdout)
		local volume = tonumber(string.match(stdout, "(%d?%d?%d)%%"))
		volume_slider.value = volume
	end)
end

local volume_slider_timer = gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = update_volume_slider,
})

local brightness_slider = wibox.widget({
	widget = wibox.widget.slider,
	bar_shape = gears.shape.rounded_rect,
	bar_height = 10,
	bar_color = "#b7b2f1",
	handle_shape = gears.shape.circle,
	handle_color = "#ffffff",
	handle_width = 30,
	handle_border_width = 1,
	handle_border_color = "#aaaaaa",
	minimum = 5,
	maximum = 100,
	value = tonumber(io.popen("light -G"):read("*all")),
})

local user_widget = wibox.widget({
	{
		image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/iconUser.png",
		widget = wibox.widget.imagebox,
	},
	{
		text = " Amitabha       ",
		font = "CaskaydiaCove Nerd Font 17",
		widget = wibox.widget.textbox,
		bg = "#000022",
	},
	nil,
	layout = wibox.layout.fixed.horizontal,
})

-- Define colors for on and off states
local on_color = "#5294E2"
local off_color = "#FFFFFF30"

-- Define font settings for text
local font = "CaskaydiaCove Nerd Font 13"
local text_color = "#000000"

-- WiFi button widget

local wifi_text = wibox.widget.textbox()

local wifi_script = [[
  sh -c "nmcli -t -f active,ssid dev wifi | egrep '^yes:' | cut -d\' -f2 | awk -F: '$1=="yes"{print substr($0,5)}'"
]]

awful.widget.watch(wifi_script, 5, function(widget, stdout)
	local wifi_name = stdout:gsub("^%s*(.-)%s*$", "%1")
	if wifi_name ~= "" then
		wifi_text:set_text("Wifi (Off)")
	else
		wifi_text:set_text("" .. tostring(wifi_name) .. "")
	end
end)

local wifi_button = wibox.widget({
	{
		{
			{
				widget = wibox.widget.imagebox,
				image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/wifi-icon-3782.png",
				resize = true,
				-- forced_height = 20,
				-- forced_width = 20,
			},
			{
				text = " WiFi",
				font = font,
				align = "center",
				valign = "center",
				widget = wibox.widget.textbox,
			},
			wifi_text,
			layout = wibox.layout.fixed.horizontal,
		},
		widget = wibox.container.margin,
		margins = 5,
	},
	bg = off_color,
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
})

-- Bluetooth button widget
local bluetooth_button = wibox.widget({
	{
		{
			{
				widget = wibox.widget.imagebox,
				image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/64x64/apps/blueradio.svg",
				resize = true,
				-- forced_height = 20,
				-- forced_width = 20,
			},
			{
				text = "Bluetooth",
				font = font,
				align = "center",
				valign = "center",
				widget = wibox.widget.textbox,
			},
			layout = wibox.layout.fixed.horizontal,
		},
		widget = wibox.container.margin,
		margins = 5,
	},
	bg = off_color,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 10)
	end,
	widget = wibox.container.background,
})

-- Toggle WiFi on/off
wifi_button:connect_signal("button::press", function()
	wifi_on = not wifi_on
	if wifi_on then
		wifi_button:set_bg("#5294E2")
		wifi_button.children[1].image = "/path/to/wifi-on.png"
		os.execute("nmcli radio wifi on")
	else
		wifi_button:set_bg("#ffffff30")
		wifi_button.children[1].image = "/path/to/wifi-off.png"
		os.execute("nmcli radio wifi off")
	end
end)

-- Toggle Bluetooth on/off

bluetooth_button:connect_signal("button::press", function()
	bluetooth_on = not bluetooth_on
	if bluetooth_on then
		bluetooth_button:set_bg("#5294E2")
		bluetooth_button.children[1].image = "/path/to/bluetooth-on.png"
	else
		bluetooth_button:set_bg("#ffffff30")
		bluetooth_button.children[1].image = "/path/to/bluetooth-off.png"
	end
end)

-- ScreenShot button widget
local Screenshot_button = wibox.widget({
	{
		{
			{
				widget = wibox.widget.imagebox,
				image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/64x64/devices/camera.svg",
				resize = true,
				-- forced_height = 20,
				-- forced_width = 20,
			},
			{
				text = " ScreenShot",
				font = font,
				align = "center",
				valign = "center",
				widget = wibox.widget.textbox,
			},
			layout = wibox.layout.fixed.horizontal,
		},
		widget = wibox.container.margin,
		margins = 5,
	},
	bg = off_color,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 10)
	end,
	widget = wibox.container.background,
})

Screenshot_button:connect_signal("button::press", function()
	awful.spawn("spectacle")
end)

local battery_text = wibox.widget.textbox()

local battery_script = [[
  sh -c "acpi | cut -d' ' -f4 | tr -d ','"
]]

-- Battery widget
local Appearance = wibox.widget({
	{
		{
			{
				widget = wibox.widget.imagebox,
				image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/64x64/apps/lximage.svg",
				resize = true,
				-- forced_height = 20,
				-- forced_width = 20,
			},
			{
				text = " Change Theme",
				font = font,
				align = "center",
				valign = "center",
				widget = wibox.widget.textbox,
			},
			-- battery_text,
			layout = wibox.layout.fixed.horizontal,
		},
		widget = wibox.container.margin,
		margins = 5,
	},
	bg = off_color,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 10)
	end,
	widget = wibox.container.background,
})

Appearance:connect_signal("button::press", function()
	awful.spawn("lxappearance")
end)

-- Set the font of the battery text widget

local popup2 = awful.popup({
	widget = {
		{
			{
				{
					{
						user_widget,
						widget = wibox.container.background,
						shape = gears.shape.rounded_rect,
						forced_width = 340,
						forced_height = 70,
						bg = "#729fcf",
						fg = "#000000",
					},
					widget = wibox.container.margin,
					margins = 8,
					forced_width = 340,
					forced_height = 70,
				},
				{
					{
						logout_menu_widget({
							font = "JetBrainsMono Nerd Font 13",
							onlock = function()
								awful.spawn.with_shell("i3lock-fancy")
							end,
						}),
						widget = wibox.container.background,
						shape = gears.shape.rounded_rect,
						forced_width = 60,
						forced_height = 70,
						bg = "#729fcf",
						fg = "#000000",
					},
					widget = wibox.container.margin,
					margins = 8,
					forced_width = 60,
					forced_height = 70,
				},
				layout = wibox.layout.fixed.horizontal,
				forced_width = 400,
				forced_height = 70,
			},
			{
				{
					id = "screenshot",
					widget = wibox.widget.imagebox,
					image = os.getenv("HOME")
							.. "/.icons/papirus-icon-theme-20230301/Papirus/64x64/devices/audio-headset.svg",
					resize = true,
					opacity = 0,
				},
				forced_height = 20,
				forced_width = 400,
				layout = wibox.layout.fixed.horizontal,
			},
			{
				{
					widget = wibox.widget.imagebox,
					image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/audio2.png",
					resize = true,
					opacity = 1,
				},
				{
					volume_slider,
					widget = wibox.container.margin,
					margins = 10,
					forced_width = 350,
					forced_height = 60,
				},
				layout = wibox.layout.fixed.horizontal,
				forced_width = 400,
				forced_height = 60,
			},
			{
				{
					id = "screenshot",
					widget = wibox.widget.imagebox,
					image = os.getenv("HOME")
							.. "/.icons/papirus-icon-theme-20230301/Papirus/64x64/devices/audio-headset.svg",
					resize = true,
					opacity = 0,
				},
				forced_height = 20,
				forced_width = 400,
				layout = wibox.layout.fixed.horizontal,
			},
			{
				{
					id = "brightness",
					widget = wibox.widget.imagebox,
					image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/brightness2.png",
					resize = true,
					opacity = 1,
				},
				{
					brightness_slider,
					widget = wibox.container.margin,
					margins = 10,
					forced_width = 350,
					forced_height = 60,
				},
				layout = wibox.layout.fixed.horizontal,
				forced_width = 400,
				forced_height = 60,
			},
			{
				{
					id = "screenshot",
					widget = wibox.widget.imagebox,
					image = os.getenv("HOME")
							.. "/.icons/papirus-icon-theme-20230301/Papirus/64x64/devices/audio-headset.svg",
					resize = true,
					opacity = 0,
				},
				forced_height = 20,
				forced_width = 400,
				layout = wibox.layout.fixed.horizontal,
			},
			{
				{
					{
						wifi_button,
						widget = wibox.container.background,
						shape = gears.shape.rounded_rect,
						forced_width = 180,
						forced_height = 70,
						bg = "#729fcf",
						fg = "#000000",
					},
					widget = wibox.container.margin,
					margins = 8,
					forced_width = 200,
					forced_height = 70,
				},
				{
					{
						bluetooth_button,
						widget = wibox.container.background,
						shape = gears.shape.rounded_rect,
						forced_width = 180,
						forced_height = 70,
						bg = "#729fcf",
						fg = "#000000",
					},
					widget = wibox.container.margin,
					margins = 8,
					forced_width = 200,
					forced_height = 70,
				},
				layout = wibox.layout.fixed.horizontal,
				forced_width = 400,
				forced_height = 70,
			},
			{
				{
					{
						Appearance,
						widget = wibox.container.background,
						shape = gears.shape.rounded_rect,
						forced_width = 180,
						forced_height = 70,
						bg = "#729fcf",
						fg = "#000000",
					},
					widget = wibox.container.margin,
					margins = 8,
					forced_width = 200,
					forced_height = 70,
				},
				{
					{
						Screenshot_button,
						widget = wibox.container.background,
						shape = gears.shape.rounded_rect,
						forced_width = 180,
						forced_height = 70,
						bg = "#729fcf",
						fg = "#000000",
					},
					widget = wibox.container.margin,
					margins = 8,
					forced_width = 200,
					forced_height = 70,
				},
				layout = wibox.layout.fixed.horizontal,
				forced_width = 400,
				forced_height = 70,
			},
			layout = wibox.layout.fixed.vertical,
		},
		margins = 10,
		widget = wibox.container.margin,
	},
	bg = "#00000099",
	border_color = "#00000099",
	border_width = 10,
	ontop = true,
	placement = function(c)
		local screen_geometry = awful.screen.focused().geometry
		return awful.placement.top_right(c, { margins = { right = 10, top = 35 } })
	end,
	shape = gears.shape.rounded_rect,
	visible = false,
	forced_width = 400,
	forced_height = 200,
})

-- Add signal to set the brightness using light
brightness_slider:connect_signal("property::value", function(slider)
	local brightness_level = math.floor(slider.value / 100 * 100)
	awful.spawn.easy_async("light -S " .. brightness_level, function()
	end)
end)

-- Add signal to set the Volume using amixer
volume_slider:connect_signal("property::value", function(slider)
	local volume_level = math.floor(slider.value / 100 * 65537)
	awful.spawn.easy_async("amixer set Master" .. volume_level, function()
	end)
end)

-- Define button callback function
button_control:connect_signal("button::release", function()
	popup2.visible = not popup2.visible
end)

-------------------------------------------------------------------------

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()

	-- Create an imagebox widget which will contain an icon indicating which layout we're using.

	local ff_launch = wibox.widget({
		image = "~/.icons/papirus-icon-theme-20230301/Papirus/22x22/apps/launch.svg",
		widget = wibox.widget.imagebox,
		resize = true,
	})
	ff_launch:buttons(gears.table.join(awful.button({}, 1, function()
		awful.spawn("firefox", false)
	end)))

	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))

	awful.screen.connect_for_each_screen(function(s)
		local fancy_taglist = require("fancy_taglist")
		s.mytaglist = fancy_taglist.new({
			screen = s,
			taglist = { buttons = taglist_buttons },
			tasklist = { buttons = tasklist_buttons },
			-- taglist_buttons  = mytagbuttons,
			-- tasklist_buttons = tasklist_buttons,
			filter = awful.widget.taglist.filter.all,
		})
	end)

	--Tasklist widget
	mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,

		disable_task_name = true,
		layout = {
			spacing_widget = {
				{
					forced_width = 5,
					forced_height = 20,
					thickness = 4,
					color = "#000000",
					widget = wibox.widget.separator,
				},
				valign = "center",
				halign = "center",
				widget = wibox.container.place,
			},
			spacing = 5,
			layout = wibox.layout.fixed.vertical,
		},
		-- not a widget instance.
		widget_template = {
			{
				wibox.widget.base.make_widget(),
				-- forced_height = 48,
				id = "background_role",
				widget = wibox.container.background,
			},
			{
				{
					id = "clienticon",
					widget = awful.widget.clienticon,
				},
				margins = 5,
				widget = wibox.container.margin,
			},
			nil,
			create_callback = function(self, c, index, objects) --luacheck: no unused args
				self:get_children_by_id("clienticon")[1].client = c
			end,
			layout = wibox.layout.align.vertical,
		},
	})

	local separator2 = wibox.widget.textbox("     ")
	separator2.forced_width = 50

	-- the wibox
	s.mywibox =
			awful.wibar({ position = "top", screen = s, height = 30, opacity = 0.9, fg = "#ffffff", bg = "#1A1B26", })

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.stack,
		expand = "none",
		{
			layout = wibox.layout.align.horizontal,
			{
				-- Left widgets
				layout = wibox.layout.fixed.horizontal,
				-- separator2,
				s.mytaglist,
				separator,
				s.mypromptbox,
				separator,
				separator,
				separator,
				separator,
				wibox.widget({
					image = "home/amitabha/.icons/papirus-icon-theme-20230301/Papirus/22x22/apps/launch.svg",
					resize_allowed = true,
					widget = wibox.widget.imagebox,
				}),
				-- s.mytasklist
			},
			nil,
			{
				-- Right widgets
				layout = wibox.layout.fixed.horizontal,
				wibox.widget.systray(),
				separator,
				{
					id = "screenshot",
					widget = wibox.widget.imagebox,
					image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/ss.png",
					resize = true,
					opacity = 1,
				},
				separator,
				batteryarc_widget({
					show_current_level = true,
					arc_thickness = 2,
					size = 24,
					font = "CaskaydiaCove Nerd Font 9",
					margins = 55,
					timeout = 10,
				}),
				separator,
				button_control,
				separator,
				logout_menu_widget({
					font = "JetBrainsMono Nerd Font 14",
					onlock = function()
						awful.spawn.with_shell("i3lock-fancy")
					end,
				}),
				-- s.mylayoutbox,
			},
		},
		{
			mytextclock,
			valign = "center",
			halign = "center",
			layout = wibox.container.place,
		},
	})

	s.mywibox:get_children_by_id("screenshot")[1]:connect_signal("button::press", function()
		awful.spawn.with_shell(
			'scrot /tmp/screenshot.png && convert /tmp/screenshot.png -resize 20% /tmp/resized_screenshot.png && dunstify -i /tmp/resized_screenshot.png " " && cp /tmp/screenshot.png ~/Pictures/file1_`date +"%Y%m%d_%H%M%S"`.png && rm /tmp/resized_screenshot.png && rm /tmp/screenshot.png'
		)
	end)

	-- a wibar for the dock
	mydock = awful.wibar({ position = "left", screen = s, width = 50, opacity = 1, bg = "#1A1B26" })

	mydock:setup({
		layout = wibox.layout.align.vertical,
		expand = "none",
		{
			layout = wibox.container.place,
			halign = "center",
			{
				layout = wibox.layout.fixed.vertical,
				spacing = 15,
				{
					id = "blank",
					widget = wibox.widget.imagebox,
					image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/8x8/",
					resize = false,
					opacity = 0,
				},
				{
					id = "rofi",
					widget = wibox.widget.imagebox,
					image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/32x32/apps/launch.svg",
					resize = false,
					opacity = 1,
				},
				{
					id = "firefox",
					widget = wibox.widget.imagebox,
					image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/32x32/apps/firefox.svg",
					resize = false,
					opacity = 1,
				},
				{
					id = "kitty",
					widget = wibox.widget.imagebox,
					image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/32x32/apps/kitty.svg",
					resize = false,
				},
				{
					id = "telegram",
					widget = wibox.widget.imagebox,
					image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/32x32/apps/telegram.svg",
					resize = false,
				},
				{
					id = "files",
					widget = wibox.widget.imagebox,
					image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/32x32/apps/Thunar.svg",
					resize = false,
				},
				{
					id = "vscode",
					widget = wibox.widget.imagebox,
					image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/32x32/apps/code.svg",
					resize = false,
				},
				{
					id = "gimp",
					widget = wibox.widget.imagebox,
					image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/32x32/apps/gimp.svg",
					resize = false,
				},
				{
					id = "vokoscreenNG",
					widget = wibox.widget.imagebox,
					image = os.getenv("HOME")
							.. "/.icons/papirus-icon-theme-20230301/Papirus/32x32/apps/vokoscreenNG.svg",
					resize = false,
				},
				{
					id = "kdeconnect",
					widget = wibox.widget.imagebox,
					image = os.getenv("HOME")
							.. "/.icons/papirus-icon-theme-20230301/Papirus/32x32/apps/kdeconnect.svg",
					resize = false,
				},
				{
					id = "keepassxc",
					widget = wibox.widget.imagebox,
					image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/32x32/apps/keepassxc.svg",
					resize = false,
				},
				layout = wibox.layout.fixed.vertical,
			},
		},
		nil,
		{
			layout = wibox.layout.fixed.vertical,
			spacing = 15,
			{
				button,
				widget = wibox.container.margin,
				margins = 5,
			},
			{
				s.mylayoutbox,
				widget = wibox.container.margin,
				margins = 5,
			},
			layout = wibox.layout.fixed.vertical,
		},
	})

	-- mouse bindings to the icons

	mydock:get_children_by_id("rofi")[1]:connect_signal("button::press", function()
		awful.spawn("rofi -show drun")
	end)

	mydock:get_children_by_id("firefox")[1]:connect_signal("button::press", function()
		awful.spawn("firefox")
	end)

	mydock:get_children_by_id("kitty")[1]:connect_signal("button::press", function()
		awful.spawn("kitty")
	end)

	mydock:get_children_by_id("vscode")[1]:connect_signal("button::press", function()
		awful.spawn("code")
	end)

	mydock:get_children_by_id("files")[1]:connect_signal("button::press", function()
		awful.spawn("thunar")
	end)

	mydock:get_children_by_id("telegram")[1]:connect_signal("button::press", function()
		awful.spawn.with_shell("telegram-desktop")
	end)

	mydock:get_children_by_id("gimp")[1]:connect_signal("button::press", function()
		awful.spawn("gimp")
	end)

	mydock:get_children_by_id("vokoscreenNG")[1]:connect_signal("button::press", function()
		awful.spawn("vokoscreenNG")
	end)

	mydock:get_children_by_id("kdeconnect")[1]:connect_signal("button::press", function()
		awful.spawn("kdeconnect-app")
	end)

	mydock:get_children_by_id("keepassxc")[1]:connect_signal("button::press", function()
		awful.spawn("keepassxc")
	end)
end)
-- }}}
