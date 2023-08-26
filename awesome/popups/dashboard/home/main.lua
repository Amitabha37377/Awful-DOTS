--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Custom Modules
local color = require("popups.color")
local user = require("popups.user_profile")

--Widgets
local header = require("popups.dashboard.home.widgets.header")
local profile = require("popups.dashboard.home.widgets.profile")
local calender = require("popups.dashboard.home.widgets.calendar")
local weather = require("popups.dashboard.home.widgets.weather")
local launch = require("popups.dashboard.home.widgets.quick_launch")
local exit = require("popups.dashboard.home.widgets.exit")



--Separator/Background
local Separator = wibox.widget.textbox("    ")
Separator.forced_height = 950
Separator.forced_width = 430

--Sidebar
local sidebar = require("popups.dashboard.home.sidebar")

--Main Wibox
local dashboard_home = awful.popup {
  screen = s,
  widget = wibox.container.background,
  ontop = true,
  bg = "#00000000",
  visible = false,
  forced_width = 430,
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

local home = wibox.widget {
  header,
  profile,
  calender,
  weather,
  launch,
  exit,
  layout = wibox.layout.fixed.vertical,
}

dashboard_home:setup {
  {
    {
      home,
      Separator,
      layout = wibox.layout.stack
    },
    sidebar,
    layout = wibox.layout.fixed.horizontal
  },
  widget = wibox.container.background,
  bg = color.background_dark,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
}


return dashboard_home
