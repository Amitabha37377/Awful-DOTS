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
  top = 8,
  bottom = 8,
  right = 13,
  left = 9,
  forced_height = 40
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
  top = 7,
  bottom = 7,
  right = 6,
  left = 11,
  forced_height = 40
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
    top = 6,
    bottom = 6,
    right = 6,
    left = 6,
  },
  widget = wibox.container.background,
  bg = color.background_lighter,
  -- forced_height = 60,
  forced_width = 104,
  halign = center,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
}

return buttons
