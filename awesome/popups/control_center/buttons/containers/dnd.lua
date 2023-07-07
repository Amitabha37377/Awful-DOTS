local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Custom Modules
local user = require("popups.user_profile")
local color = require("popups.color")



local dnd = wibox.widget {
  {
    {
      image = os.getenv("HOME") .. "/.config/awesome/popups/control_center/assets/dnd.png",
      widget = wibox.widget.imagebox,
      resize = true,
      shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 20)
      end,

    },
    widget = wibox.container.margin,
    top = dpi(15),
    bottom = dpi(15),
    left = dpi(18),
    right = dpi(14),
  },
  widget = wibox.container.background,
  bg = color.grey,
  shape = function(cr, width, height)
    gears.shape.rounded_bar(cr, dpi(52), dpi(50))
  end
}


return dnd
