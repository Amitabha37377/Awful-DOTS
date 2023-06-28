--Standard Modules
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

--Main Logo
local button1 = wibox.widget {
  {
    {
      widget = wibox.widget.imagebox,
      image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/power3.png",
      resize = true,
      opacity = 1,
    },
    left   = 5,
    right  = 5,
    top    = 5,
    bottom = 5,
    widget = wibox.container.margin
  },
  bg = "1A1B26",
  shape = gears.shape.rounded_rect,
  widget = wibox.container.background,
  -- forced_height = 53,
  -- forced_width = 53,
}

return button1
