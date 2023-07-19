local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local color = require("popups.color")

--Image widget
local image = wibox.widget {
  widget = wibox.widget.imagebox,
  image = os.getenv("HOME") .. "/.config/awesome/popups/screen_record/assets/full.png",
  resize = true,
  opacity = 1,

}

local text = {
  -- text = user.name,
  markup = '<span color="' ..
      color.white .. '" font="Ubuntu Nerd Font 12">' .. "Timer" .. '</span>',
  font = "Ubuntu Nerd Font Bold 14",
  widget = wibox.widget.textbox,
  fg = color.white,
  align = "center"
}

local container = wibox.widget {
  {
    image,
    text,
    layout = wibox.layout.fixed.vertical
  },
  widget = wibox.container.margin,
  left = dpi(30),
  right = dpi(30),
  top = dpi(10),
  bottom = dpi(25)

}

--Main Widget
local button = wibox.widget {
  {
    {
      {
        image,
        layout = wibox.layout.fixed.vertical
      },
      left   = dpi(25),
      right  = dpi(25),
      top    = dpi(25),
      bottom = dpi(25),
      widget = wibox.container.margin
    },
    layout = wibox.container.place
  },
  bg = color.background_lighter,
  shape = gears.shape.rounded_rect,
  widget = wibox.container.background,
  forced_height = dpi(140),
  forced_width = dpi(150),
  -- border_width = dpi(1.5),
  -- border_color = color.white
}

button:connect_signal("mouse::enter", function()
  button.bg = color.blueish_white
  image.image = os.getenv("HOME") .. "/.config/awesome/popups/screen_record/assets/full-hover.png"
end)

button:connect_signal("mouse::leave", function()
  image.image = os.getenv("HOME") .. "/.config/awesome/popups/screen_record/assets/full.png"
  button.bg = color.background_lighter
end)

button:connect_signal("button::press", function()
  button.bg = color.blue
end)

button:connect_signal("button::release", function()
  button.bg = color.blueish_white
end)



return button
