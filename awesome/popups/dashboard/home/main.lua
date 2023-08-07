--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")

--Custom Modules
local color = require("popups.color")
local user = require("popups.user_profile")

--Separator/Background
local Separator = wibox.widget.textbox("    ")
Separator.forced_height = 950
Separator.forced_width = 500

--Main Wibox
local dashboard_home = awful.popup {
  screen = s,
  widget = wibox.container.background,
  ontop = true,
  bg = "#00000000",
  visible = false,
  forced_width = 400,
  maximum_height = 950,
  placement = function(c)
    awful.placement.top_left(c,
      { margins = { top = dpi(50), bottom = dpi(8), left = dpi(8), right = dpi(8) } })
  end,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
  opacity = 1
}

dashboard_home:setup {
  {
    Separator,
    layout = wibox.layout.stack
  },
  widget = wibox.container.background,
  bg = color.background_dark,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
}

return dashboard_home
