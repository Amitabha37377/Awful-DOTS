local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local color = require("popups.color")
local icon_path = os.getenv("HOME") .. "/.config/awesome/popups/control_center/assets/"

--Powerbutton
local power = wibox.widget {
  {
    image = icon_path .. "power3.png",
    widget = wibox.widget.imagebox,
    resize = true,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 20)
    end,

  },
  widget = wibox.container.margin,
  top = dpi(8),
  bottom = dpi(8),
  right = dpi(13),
  left = dpi(9),
  forced_height = dpi(40)
}

--notification button
local notifications = wibox.widget {
  {
    image = icon_path .. "notification.png",
    widget = wibox.widget.imagebox,
    resize = true,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 20)
    end,

  },
  widget = wibox.container.margin,
  top = dpi(7),
  bottom = dpi(7),
  right = dpi(6),
  left = dpi(11),
  forced_height = dpi(40)
}

--Separator
local vertical_separator = wibox.widget {
  orientation = 'vertical',
  forced_height = dpi(1.5),
  forced_width = dpi(1.5),
  span_ratio = 0.55,
  widget = wibox.widget.separator,
  color = "#a9b1d6",
  border_color = "#a9b1d6",
  opacity = 0.55
}

--Main Widget
local buttons = wibox.widget {
  {
    {
      power,
      vertical_separator,
      notifications,
      layout = wibox.layout.fixed.horizontal,
    },
    widget = wibox.container.margin,
    top = dpi(6),
    bottom = dpi(6),
    right = dpi(6),
    left = dpi(6),
  },
  widget = wibox.container.background,
  bg = color.background_lighter,
  -- forced_height = 60,
  forced_width = dpi(104),
  halign = center,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
}

return buttons
