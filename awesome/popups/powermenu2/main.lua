local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local color = require("popups.color")

local left = require("popups.powermenu.left.left")
local image_bg = require("popups.powermenu.left.background")

local Separator = wibox.widget.textbox("    ")
Separator.forced_height = 660
Separator.forced_width = 600

local powermenu = awful.popup {
  screen = s,
  widget = wibox.container.background,
  ontop = true,
  bg = "#00000000",
  visible = false,
  -- maximum_width = 200,
  placement = function(c)
    awful.placement.centered(c,
      { margins = { top = dpi(0), bottom = dpi(0), left = dpi(0), right = dpi(0) } })
  end,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 0)
  end,
  opacity = 1,
  forced_height = 660,
  forced_width = 1200,
}

powermenu:setup {

  left,
  {
    Separator,
    widget = wibox.container.background,
    bg = "#0f1b27",
    border_width = dpi(3),
    border_color = color.blue
  },
  -- left,
  layout = wibox.layout.fixed.horizontal
}

return powermenu
