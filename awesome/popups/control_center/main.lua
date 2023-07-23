--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Custom Modules
local color = require("popups.color")

--Widgets
local Separator = wibox.widget.textbox("    ")
Separator.forced_height = dpi(11)

--Control Center Items
local profile = require("popups.control_center.header.header")
local buttons = require("popups.control_center.header.button")

local left_buttons = require("popups.control_center.buttons.left")
local silent = require("popups.control_center.buttons.silent")
local dark = require("popups.control_center.buttons.darkmode")

local brightness = require("popups.control_center.sliders.brightness")
local volume = require("popups.control_center.sliders.volume")

local music_player = require("popups.control_center.music.music")

--Main Wibox
local control = awful.popup {
  screen = s,
  widget = wibox.container.background,
  ontop = true,
  bg = "#00000000",
  visible = false,
  -- maximum_width = 200,
  placement = function(c)
    awful.placement.top_right(c,
      { margins = { top = dpi(50), bottom = dpi(8), left = dpi(8), right = dpi(8) } })
  end,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
  opacity = 1
}

control:setup {
  {
    {
      {
        profile,
        Separator,
        buttons,
        layout = wibox.layout.fixed.horizontal
      },
      widget = wibox.container.margin,
      top    = dpi(11),
      bottom = dpi(11),
      left   = dpi(11),
      right  = dpi(11)
    },
    {
      {
        left_buttons,
        Separator,
        {
          silent,
          Separator,
          dark,
          layout = wibox.layout.fixed.vertical
        },
        layout = wibox.layout.fixed.horizontal
      },
      widget = wibox.container.margin,
      top = 0,
      bottom = dpi(11),
      right = dpi(11),
      left = dpi(11),
    },
    {
      brightness,
      widget = wibox.container.margin,
      top = 0,
      bottom = dpi(11),
      right = dpi(11),
      left = dpi(11),
    },
    {
      volume,
      widget = wibox.container.margin,
      top = 0,
      bottom = dpi(11),
      right = dpi(11),
      left = dpi(11),
    },
    {
      music_player,
      widget = wibox.container.margin,
      top = 0,
      bottom = dpi(11),
      right = dpi(11),
      left = dpi(11),
    },
    layout = wibox.layout.fixed.vertical
  },
  widget = wibox.container.background,
  bg = color.background_dark,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,

}

awesome.connect_signal("widget::control", function()
  control.visible = false
end)




return control
