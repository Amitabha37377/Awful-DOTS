local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local color = require("popups.color")
local background = require("popups.powermenu.left.background")

--UserImage
local image = wibox.widget {
  {
    image = os.getenv("HOME") .. "/.config/awesome/popups/control_center/assets/user.png",
    widget = wibox.widget.imagebox,
    resize = true,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 20)
    end,
    -- opacity = 0
  },
  widget = wibox.container.margin,
  top = dpi(3),
  bottom = dpi(3),
  right = dpi(10),
  left = dpi(7),
  forced_height = dpi(300),
  forced_width = dpi(300)
}

--User Image
local uptime_header = wibox.widget {
  {
    {
      {
        -- text = user.name,
        markup = '<span color="' ..
            color.background_dark .. '" font="Ubuntu Nerd Font Bold 17">' .. 'Uptime' .. '</span>',
        font = "Ubuntu Nerd Font Bold 14",
        widget = wibox.widget.textbox,
        fg = color.white
      },
      widget = wibox.container.margin,
      top = dpi(7),
      bottom = dpi(0),
      right = dpi(7),
      left = dpi(7),
    },
    layout = wibox.container.place
  },
  widget = wibox.container.background,
  bg = color.blue,
  forced_width = dpi(400),
  border_width = dpi(2),
  border_color = color.blue,
  shape = function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, 5)
  end,

}

--Uptime Show
local get_uptime = "uptime | awk " ..
    "-F'" .. "( |,|:)+' " .. "'" .. '{print $6,$7" ' .. '",$8,"hours ",$9,"minutes "' .. "}'"
local uptime = io.popen(get_uptime):read("*all")

local uptime_time = wibox.widget {
  {
    {
      {
        -- text = user.name,
        markup = '<span color="' ..
            color.blueish_white .. '" font="Ubuntu Nerd Font 17">' .. uptime .. '</span>',
        font = "Ubuntu Nerd Font Bold 14",
        widget = wibox.widget.textbox,
        fg = color.white
      },
      widget = wibox.container.margin,
      top = dpi(11),
      bottom = dpi(11),
      right = dpi(7),
      left = dpi(7),
    },
    layout = wibox.container.place
  },
  widget = wibox.container.background,
  bg = color.background_dark,
  forced_width = dpi(400),
  border_width = dpi(2),
  border_color = color.blue,
  shape = function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, 5)
  end,
}

local main = {
  {
    background,
    {
      {
        {
          {
            image,
            layout = wibox.container.place
          },
          widget = wibox.container.margin,
          top = 80,
          bottom = 60,
        },
        {
          {
            {
              uptime_header,
              uptime_time,
              layout = wibox.layout.fixed.vertical
            },
            layout = wibox.container.place
          },
          widget = wibox.container.margin,
          top = 0,
          bottom = dpi(80)
        },
        layout = wibox.layout.fixed.vertical
      },
      widget = wibox.container.margin,
      top = dpi(20),
      bottom = dpi(20),
      left = dpi(20),
      right = dpi(20),
      forced_height = dpi(660),
      forced_width = dpi(600)
    },

    layout = wibox.layout.stack
  },
  widget = wibox.container.background,
  bg = color.background_dark,
  border_width = dpi(3),
  border_color = color.blue
}

return main
