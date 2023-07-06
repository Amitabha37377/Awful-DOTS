--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

--Custom Modules
local color = require("popups.color")

--Widgets
local Separator = wibox.widget.textbox("    ")
Separator.forced_height = 11

local profile = require("popups.control_center.header.header")
local buttons = require("popups.control_center.header.button")

local left_buttons = require("popups.control_center.buttons.left")
local silent = require("popups.control_center.buttons.silent")
local dark = require("popups.control_center.buttons.darkmode")

local brightness = require("popups.control_center.sliders.brightness")
local volume = require("popups.control_center.sliders.volume")

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
      { margins = { top = 50, bottom = 8, left = 8, right = 8 } })
  end,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
  opacity = 0.9
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
      top    = 11,
      bottom = 11,
      left   = 11,
      right  = 11
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
      bottom = 11,
      right = 11,
      left = 11,
    },
    {
      brightness,
      widget = wibox.container.margin,
      top = 0,
      bottom = 11,
      right = 11,
      left = 11,
    },
    {
      volume,
      widget = wibox.container.margin,
      top = 0,
      bottom = 11,
      right = 11,
      left = 11,
    },
    layout = wibox.layout.fixed.vertical
  },
  widget = wibox.container.background,
  bg = color.background_dark,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,

}

return control
