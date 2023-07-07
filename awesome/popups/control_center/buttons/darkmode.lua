--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi


--Custom Modules
local user = require("popups.user_profile")
local color = require("popups.color")
local image = require("popups.control_center.buttons.containers.dark")

--Separator
local Separator = wibox.widget.textbox("    ")
Separator.forced_height = dpi(4)


-----------------------------------------
--DarkMode Button
-----------------------------------------
local dark_status = wibox.widget {
  -- text = user.name,
  markup = '<span color="' .. color.white .. '" font="Ubuntu Nerd Font 11">' .. "On" .. '</span>',
  font = "Ubuntu Nerd Font Bold 14",
  widget = wibox.widget.textbox,
  fg = color.white
}

--text
local text_dark = wibox.widget {
  {
    {
      -- text = user.name,
      markup = '<span color="' ..
          color.blueish_white .. '" font="Ubuntu Nerd Font bold 11">' .. "Dark Mode" .. '</span>',
      font = "Ubuntu Nerd Font Bold 14",
      widget = wibox.widget.textbox,
      fg = color.white
    },
    Separator,
    dark_status,
    layout = wibox.layout.fixed.vertical

  },
  widget = wibox.container.margin,
  top = dpi(20),
  bottom = dpi(18),
  right = dpi(8),
  left = dpi(8),
  forced_height = dpi(80)
}

--UserImage
local image_dark = wibox.widget {
  image,
  widget = wibox.container.margin,
  top = dpi(13),
  bottom = dpi(13),
  right = dpi(10),
  left = dpi(7),
  forced_height = dpi(80)
}

--Button Functionality
local dark_on = true

image:connect_signal("button::press", function()
  dark_on = not dark_on
  if dark_on then
    image:set_bg("#5680b8")
    dark_status:set_markup_silently('<span color="' ..
      color.white .. '" font="Ubuntu Nerd Font 11">' .. "on" .. '</span>')
  else
    image:set_bg(color.grey)
    dark_status:set_markup_silently('<span color="' ..
      color.white .. '" font="Ubuntu Nerd Font 11">' .. "off" .. '</span>')
  end
end)


--Main Widget
local button = wibox.widget {
  {
    {
      {
        {
          image_dark,
          text_dark,
          layout = wibox.layout.fixed.horizontal,
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
  forced_width = dpi(202),
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,

}

return button
