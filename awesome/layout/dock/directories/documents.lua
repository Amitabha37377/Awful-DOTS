--Standard Modules
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Colors
local color = require("layout.dock.color")
local icon_path = "/.icons/papirus-icon-theme-20230301/Papirus/48x48/places/"

--Main Widget
local button = wibox.widget {
  {
    {
      widget = wibox.widget.imagebox,
      image = os.getenv("HOME") .. icon_path .. "folder-documents.svg",
      resize = true,
      opacity = 1,
    },
    left   = 0,
    right  = 0,
    top    = 0,
    bottom = dpi(2),
    widget = wibox.container.margin
  },
  bg = color.background_dark,
  shape = gears.shape.rounded_rect,
  widget = wibox.container.background,
  forced_height = dpi(48),
  forced_width = dpi(48),
}

--Open app on click
button:connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    awful.spawn.with_shell("thunar ~/Documents/")
  end
end)


--Hover highlight effects
button:connect_signal("mouse::enter", function()
  button.bg = color.background_lighter
end)

button:connect_signal("mouse::leave", function()
  button.bg = color.background_dark
end)

button:connect_signal("button::press", function()
  button.bg = color.background_morelight
end)

button:connect_signal("button::release", function()
  button.bg = color.background_lighter
end)


return button
