-- Standard awesome library
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Theme handling library
local beautiful = require("beautiful") -- for awesome.icon

local M = {}                           -- menu
local _M = {}                          -- module

-- reading
-- https://awesomewm.org/apidoc/popups%20and%20bars/awful.menu.html

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- This is used later as the default terminal and editor to run.
-- local terminal = "xfce4-terminal"
local terminal = RC.vars.terminal

-- Variable definitions
-- This is used later as the default terminal and editor to run.
local editor = "nvim"
local editor_cmd = terminal .. " -e " .. editor

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

M.awesome = {
	{
		"Hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "Manual",          terminal .. " -e man awesome" },
	{ "Edit config",     editor_cmd .. " " .. awesome.conffile },
	{ "Terminal",        terminal },
	{ "Shutdown/Logout", "oblogout" },
	{ "Restart",         awesome.restart },
	{
		"Quit",
		function()
			awesome.quit()
		end,
	},
}

M.favorite = {
	{ "Screen Record", "vokoscreenNG" },
	{ "Files",         "thunar" },
	{ "VS Code",       "code" },
	{ "Firefox",       "firefox",       awful.util.getdir("config") .. "/firefox.png" },
	{ "GIMP",          "gimp" },
	{ "KDEconnect",    "kdeconnect-app" },
}

M.network_main = {
	{ "wicd-curses", "wicd-curses" },
	{ "wicd-gtk",    "wicd-gtk" },
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
	-- Main Menu
	local menu_items = {
		{ "Awesome",          M.awesome, beautiful.awesome_subicon },
		{ "Open Terminal",    terminal },
		{ "Change Wallpaper", "nitrogen" },
		{ "Favorite",         M.favorite },
	}

	return menu_items
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, {
	__call = function(_, ...)
		return _M.get(...)
	end,
})
