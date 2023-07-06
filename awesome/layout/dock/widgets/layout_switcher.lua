--Standard MOdules
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Colors
local color = require("layout.dock.color")

local mylayoutbox = awful.widget.layoutbox()
mylayoutbox:buttons(gears.table.join(
  awful.button({}, 1, function()
    awful.layout.inc(1)
  end),
  awful.button({}, 3, function()
    awful.layout.inc(-1)
  end),
  awful.button({}, 4, function()
    awful.layout.inc(1)
  end),
  awful.button({}, 5, function()
    awful.layout.inc(-1)
  end)
))

-- mylayoutbox.forced_height =

local layoutbox = wibox.widget {
  {
    mylayoutbox,
    left   = 0,
    right  = 0,
    top    = dpi(5),
    bottom = dpi(5),
    widget = wibox.container.margin

  },
  bg = color.background_dark,
  shape = gears.shape.rounded_rect,
  widget = wibox.container.background,
  forced_height = dpi(48),
  forced_width = dpi(48),

}

return layoutbox
