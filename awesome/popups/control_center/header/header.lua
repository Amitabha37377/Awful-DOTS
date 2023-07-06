--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

--Custom Modules
local user = require("popups.user_profile")
local color = require("popups.color")

--Username
local username = wibox.widget {
  {
    -- text = user.name,
    markup = '<span color="' .. color.blueish_white .. '" font="Ubuntu Nerd Font Bold 14">' .. user.name .. '</span>',
    font = "Ubuntu Nerd Font Bold 14",
    widget = wibox.widget.textbox,
    fg = color.white
  },
  widget = wibox.container.margin,
  top = 5,
  bottom = 5,
  right = 5,
  left = 5,
}

--UserImage
local image = wibox.widget {
  {
    image = os.getenv("HOME") .. "/.config/awesome/popups/control_center/assets/user.png",
    widget = wibox.widget.imagebox,
    resize = true,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 20)
    end,

  },
  widget = wibox.container.margin,
  top = 3,
  bottom = 3,
  right = 10,
  left = 7,
  forced_height = 40
}

--Main Widget
local profile = wibox.widget {
  {
    {
      image,
      username,
      layout = wibox.layout.fixed.horizontal,
    },
    widget = wibox.container.margin,
    top = 3,
    bottom = 3,
    right = 3,
    left = 3,
  },
  widget = wibox.container.background,
  bg = color.background_lighter,
  -- forced_height = 60,
  forced_width = 300,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,

}

return profile
