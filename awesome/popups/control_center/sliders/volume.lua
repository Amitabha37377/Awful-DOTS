--Standard Modules
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi

-- Custom modules
local color = require("popups.color")
local slider = require("popups.control_center.sliders.volume_slider")


--Text
local text = wibox.widget {
  {
    markup = '<span color="' ..
        color.blueish_white .. '" font="Ubuntu Nerd Font bold 11">' .. "Volume" .. '</span>',
    font = "Ubuntu Nerd Font Bold 14",
    widget = wibox.widget.textbox,
    fg = color.white
  },
  widget = wibox.container.margin,
  top = dpi(10),
  bottom = dpi(12),
  right = dpi(8),
  left = dpi(8),
}

--Main Container
local slider = wibox.widget {
  {
    {
      {
        {
          text,
          slider,
          layout = wibox.layout.fixed.vertical,
        },
        widget = wibox.container.margin,
        top = dpi(3),
        bottom = dpi(6),
        left = dpi(2),
        right = 0,
      },
      layout = wibox.layout.fixed.vertical
    },
    widget = wibox.container.margin,
    top = dpi(3),
    bottom = dpi(3),
    right = dpi(3),
    left = dpi(3),
  },
  widget = wibox.container.background,
  bg = color.background_lighter,
  -- forced_height = 60,
  forced_width = dpi(410),
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
}

return slider
