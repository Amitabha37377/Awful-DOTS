--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Color modules
local color = require("popups.color")

local create_button = function(text, text_color, bg_color, bg_hover, bg_press)
  local textbox = wibox.widget {
    markup = '<span color="' ..
        text_color .. '" font="Ubuntu Nerd Font Bold 18">' .. text .. '</span>',
    font = "Ubuntu Nerd Font Bold 14",
    widget = wibox.widget.textbox,
    fg = color.white
  }

  local button = wibox.widget {
    {
      textbox,
      widget = wibox.container.margin,
      top = dpi(9),
      bottom = dpi(9),
      right = dpi(8),
      left = dpi(11),
    },
    widget = wibox.container.background,
    bg = bg_color,
    forced_width = dpi(45),
    -- forced_height = dpi(45),
    shape = function(cr, width, height)
      gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, 5)
    end,
  }

  local button_final = wibox.widget {
    button,
    widget = wibox.container.margin,
    top = dpi(4),
    bottom = dpi(4)
  }

  button:connect_signal("mouse::enter", function()
    button.bg = bg_hover
  end)

  button:connect_signal("mouse::leave", function()
    button.bg = bg_color
  end)

  button:connect_signal("button::press", function()
    button.bg = bg_press
  end)

  button:connect_signal("button::release", function()
    button.bg = bg_hover
  end)

  return button_final
end

local home = create_button('', color.grey, color.background_lighter, color.background_lighter,
  color.background_lighter)
local sys_monitor = create_button('', color.grey, color.bg_blackest, color.background_dark, color.background_lighter)
local todo = create_button('', color.grey, color.bg_blackest, color.background_dark, color.background_lighter)
local settings = create_button('', color.grey, color.bg_blackest, color.background_dark, color.background_lighter)

local main = wibox.widget {
  {
    {
      home,
      todo,
      sys_monitor,
      settings,
      layout = wibox.layout.fixed.vertical
    },
    widget = wibox.container.margin,
    left = dpi(7),
    right = dpi(7),
    top = dpi(10)
  },
  widget = wibox.container.background,
  bg = color.bg_blackest,
  forced_height = dpi(950),
}

return main
