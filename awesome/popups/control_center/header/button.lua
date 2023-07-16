local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local color = require("popups.color")
local icon_path = os.getenv("HOME") .. "/.config/awesome/popups/control_center/assets/"

local powermenu = require("popups.powermenu.main")

--Powerbutton
local power = wibox.widget { {
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
},
  widget = wibox.container.background,
  bg = color.background_lighter,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 4)
  end,

}

--Hover highlight effects
power:connect_signal("mouse::enter", function()
  power.bg = "#343b58"
end)

power:connect_signal("mouse::leave", function()
  power.bg = color.background_lighter
end)

power:connect_signal("button::press", function()
  power.bg = color.background_morelight
end)

power:connect_signal("button::release", function()
  power.bg = "#343b58"
end)

power:connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    powermenu.visible = not powermenu.visible
    awesome.emit_signal("widget::control")
  end
end)



--notification button
local notifications = wibox.widget { {
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
},
  widget = wibox.container.background,
  bg = color.background_lighter,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 4)
  end,

}

--Hover highlight effects
notifications:connect_signal("mouse::enter", function()
  notifications.bg = "#343b58"
end)

notifications:connect_signal("mouse::leave", function()
  notifications.bg = color.background_lighter
end)

notifications:connect_signal("button::press", function()
  notifications.bg = color.background_morelight
end)

notifications:connect_signal("button::release", function()
  notifications.bg = "#343b58"
end)


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
