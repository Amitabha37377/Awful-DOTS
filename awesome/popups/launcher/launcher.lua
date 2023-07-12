local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local bling = require("bling")
local color = require("popups.color")

--launcher Button
local button = require("layout.dock.apps.launcher")

--Arguments
local args = {
  apps_per_column = 1,
  sort_alphabetically = false,
  reverse_sort_alphabetically = true,
}

--App Launcher
local app_launcher = bling.widget.app_launcher(args)

--Toggle App Launcher
button:connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    app_launcher:toggle()
  end
end)
