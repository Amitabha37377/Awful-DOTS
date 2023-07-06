--Standard Modules
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Main Logo
local button1 = wibox.widget {
  {
    {
      widget = wibox.widget.imagebox,
      image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/power3.png",
      resize = true,
      opacity = 1,
    },
    left   = dpi(5),
    right  = dpi(5),
    top    = dpi(5),
    bottom = dpi(5),
    widget = wibox.container.margin
  },
  bg = "1A1B26",
  shape = gears.shape.rounded_rect,
  widget = wibox.container.background,
  -- forced_height = 53,
  -- forced_width = 53,
}

return button1
