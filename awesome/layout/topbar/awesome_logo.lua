--Standard Modules
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

--Main Logo
local button1 = wibox.widget {
  {
    {
      widget = wibox.widget.imagebox,
      image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/awesome-config-logo.jpg",
      resize = true,
      opacity = 1,
    },
    left   = 7,
    right  = 7,
    top    = 7,
    bottom = 7,
    widget = wibox.container.margin
  },
  bg = "1A1B26",
  shape = gears.shape.rounded_rect,
  widget = wibox.container.background,
}

return button1
