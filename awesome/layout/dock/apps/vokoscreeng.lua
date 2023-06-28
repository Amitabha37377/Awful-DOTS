--Standard Modules
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

--Colors
local color = require("layout.dock.color")
local icon_path = require("layout.dock.icon_path")

--Main Widget
local button = wibox.widget {
  {
    {
      widget = wibox.widget.imagebox,
      image = os.getenv("HOME") .. icon_path .. "vokoscreenNG.svg",
      resize = true,
      opacity = 1,
    },
    left   = 2,
    right  = 2,
    top    = 4,
    bottom = 4,
    widget = wibox.container.margin
  },
  bg = color.background_dark,
  shape = gears.shape.rounded_rect,
  widget = wibox.container.background,
  forced_height = 48,
  forced_width = 48,
}

--Open app on click
button:connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    awful.spawn.with_shell("vokoscreenNG")
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
