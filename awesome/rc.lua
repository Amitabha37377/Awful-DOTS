-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
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
-- Table of layouts to cover with awful.layout.inc, order matters.
-- a variable needed in main.tags, and statusbar
RC.layouts = main.layouts()

-- Tags
-- Define a tag table which hold all screen tags.
-- a variable needed in rules, tasklist, and globalkeys
RC.tags = main.tags()

--  Menu
-- Create a laucher widget and a main menu
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

---------------------------------------------------------------------
---------------------------------------------------------------------
--Too lazy to make a separate file for these-------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------

--Add window borders
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
	c.border_color = "#1a1b26"
end)
client.connect_signal("unfocus", function(c)
	c.border_color = "#1a1b26"
end)
-- }}}
client.connect_signal("focus", function(c)
	c.border_width = 5
end)
client.connect_signal("unfocus", function(c)
	c.border_width = 5
end)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	if not awesome.startup then
		awful.client.setslave(c)
	end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

--Grab the focus on opened window when swotching workspaces
tag.connect_signal("property::selected", function(t)
	local selected = tostring(t.selected) == "false"
	if selected then
		local focus_timer = timer({ timeout = 0.2 })
		focus_timer:connect_signal("timeout", function()
			local c = awful.mouse.client_under_pointer()
			if not (c == nil) then
				client.focus = c
				c:raise()
			end
			focus_timer:stop()
		end)
		focus_timer:start()
	end
end)

local last_focused_client = nil

client.connect_signal("focus", function(c)
	last_focused_client = c
end)

client.connect_signal("unmanage", function(c)
	local screen = awful.screen.focused()
	if screen then
		local clients = screen.clients
		if #clients > 0 then
			local index = #clients
			while index > 0 and clients[index] == c do
				index = index - 1
			end
			local client_to_focus = clients[index] or last_focused_client or clients[#clients]
			client.focus = client_to_focus
			client_to_focus:raise()
		end
	end
end)


awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.centered --[[ + awful.placement.no_overlap + awful.placement.no_offscreen ]]
		}
	},
}

--Autostart Applications

-- Compositor
awful.spawn.with_shell("picom --daemon")

--Wallpaper
awful.spawn.with_shell("nitrogen --restore")
-- awful.spawn.with_shell("feh --bg-scale ~/.config/awesome/Wallpapers/catMachup.jpg")
-- awful.spawn.with_shell("feh --bg-scale ~/.config/awesome/Wallpapers/hyprland_kitty.jpeg")

--Other utilities
awful.util.spawn("nm-applet")
awful.spawn.with_shell('xinput set-prop "ELAN0791:00 04F3:30FD Touchpad" "libinput Tapping Enabled" 1')

--Lock Screen With i3lock
awful.spawn.with_shell("sleep 1s && xss-lock i3lock")




-- require("popups.control_center.main")
