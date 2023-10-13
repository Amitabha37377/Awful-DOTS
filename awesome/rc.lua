-- If LuaRocks is installed, make sure that packages installed through it are
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

-- Menubar
local menubar = require("menubar")

RC = {} -- global namespace, on top before require any modules
RC.vars = require("main.user-variables")

-- Error handling
require("main.error-handling")

-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.wallpaper = RC.vars.wallpaper

modkey = RC.vars.modkey

-- Custom Local Library
local main = {
	layouts = require("main.layouts"),
	tags = require("main.tags"),
	menu = require("main.menu"),
	rules = require("main.rules"),
}

--Notifications
require("deco.notifications")

-- Keys and Mouse Binding
local binding = {
	globalbuttons = require("binding.globalbuttons"),
	clientbuttons = require("binding.clientbuttons"),
	globalkeys = require("binding.globalkeys"),
	bindtotags = require("binding.bindtotags"),
	clientkeys = require("binding.clientkeys"),
}

-- Layouts
RC.layouts = main.layouts()

-- Tags
RC.tags = main.tags()

--  Menu
RC.mainmenu = awful.menu({
	items = main.menu(),
	theme = {
		width = 250,
		height = 30,
		font = "Ubuntu Nerd Font 14",
		bg_normal = "#00000080",
		bg_focus = "#729fcf",
		border_width = 3,
		border_color = "#000000",
	},
})

-- a variable needed in statusbar (helper)
RC.launcher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = RC.mainmenu })
-- Menubar configuration
menubar.utils.terminal = RC.vars.terminal


-- Mouse and Key bindings
RC.globalkeys = binding.globalkeys()
RC.globalkeys = binding.bindtotags(RC.globalkeys)

-- Set root
root.buttons(binding.globalbuttons())
root.keys(RC.globalkeys)

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Statusbar: Wibar
require("layout.topbar.topbar")
require("layout.dock.dock")
require("layout.dock.dock2")
require("popups.lockscreen")
--Wallpaper
require("deco.wall")
-- gears.wallpaper.maximized("/home/amitabha/.config/awesome/Wallpapers/catMachup.jpg", s)

--Popup Launcher
require("popups.launcher.launcher")
require("popups.launcher.launcher2")

--Osds
require("popups.osds.volume_osd")

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = main.rules(binding.clientkeys(), binding.clientbuttons())

-- Signals
require("main.signals")

--Link the themes directory
beautiful.init("~/.config/awesome/themes/mytheme/theme.lua")

--Gaps
beautiful.useless_gap = 4

--CLient borders and autofocus
require("main.client")

--Autostart applications
awful.spawn.with_shell("picom --daemon")
awful.util.spawn("nm-applet")
awful.spawn.with_shell('xinput set-prop "ELAN0791:00 04F3:30FD Touchpad" "libinput Tapping Enabled" 1')
awful.spawn.with_shell([[sleep 1s && xss-lock  awesome-client 'awesome.emit_signal("screen::lock")']])
-- awful.spawn.with_shell("sleep 1s && xss-lock i3lock")
