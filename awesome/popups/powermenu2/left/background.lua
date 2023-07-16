local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

local color     = require("popups.color")

--Image Background

local image     = wibox.widget {
  {
    image = os.getenv("HOME") .. "/.config/awesome/popups/powermenu/assets/1.png",
    widget = wibox.widget.imagebox,
    resize = true,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 0)
    end,

  },
  widget = wibox.container.margin,
  top = dpi(0),
  bottom = dpi(0),
  right = dpi(0),
  left = dpi(0),
  forced_height = dpi(660),
  forced_width = dpi(600)
}

return image
