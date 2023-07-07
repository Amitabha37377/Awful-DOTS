local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Custom Modules
local user = require("popups.user_profile")
local color = require("popups.color")



local bluetooth = wibox.widget {
  {
    {
      image = os.getenv("HOME") .. "/.config/awesome/popups/control_center/assets/bluetooth.png",
      widget = wibox.widget.imagebox,
      resize = true,
      shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 20)
      end,

    },
    widget = wibox.container.margin,
    top = dpi(12),
    bottom = dpi(12),
    left = dpi(10),
    right = dpi(10),
  },
  widget = wibox.container.background,
  bg = color.grey,
  shape = function(cr, width, height)
    gears.shape.rounded_bar(cr, dpi(52), dpi(50))
  end
}

return bluetooth
