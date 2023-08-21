local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Custom Modules
local color = require("popups.color")
local user = require("popups.user_profile")

------------------------
--Profile Image---------
------------------------

local image = wibox.widget {
  image = user.image_path,
  widget = wibox.widget.imagebox,
  resize = true,
  forced_height = dpi(120),
  forced_width = dpi(120)
}

------------------------
--Profile Texts---------
------------------------

-- Distro ----------
--------------------

-- local distro = io.popen('distro | grep "Name:" | awk ' ..
--   "'{sub(/^Name: /, " .. '""' .. "); print}' | awk '" .. '{print $1 " " $2 " " $3}' .. "'"
--
-- ):read("*all")

local distro = io.popen([[distro | grep "Name:" | awk '{sub(/^Name: /, ""); print}' | awk '{print $1 " " $2 " " $3}'
]]):read("*all")



local text = '<span color="' .. color.blueish_white .. '" font="Ubuntu Nerd Font 15">' .. '  :   ' .. distro .. '</span>'
local icon = '<span color="' .. color.red .. '" font="Ubuntu Nerd Font bold 16">' .. '' .. '</span>'

local distro_textbox = wibox.widget {
  -- text = user.name,
  markup = icon .. text,
  font = "Ubuntu Nerd Font Bold 14",
  widget = wibox.widget.textbox,
  fg = color.white,
  -- forced_width = dpi(300),
}

local distro_text = wibox.widget {
  distro_textbox,
  widget = wibox.container.margin,
  top = dpi(5),
  bottom = dpi(5),
  right = dpi(5),
  left = dpi(25),
  forced_height = dpi(40)
}

awful.spawn.easy_async_with_shell(
  [[distro | grep "Name:" | awk '{sub(/^Name: /, ""); print}' | awk '{print $1 " " $2 " " $3}']], function(out)
    distro_textbox.markup = icon .. '<span color="' ..
        color.blueish_white .. '" font="Ubuntu Nerd Font 15">' .. '  :   ' .. out .. '</span>'
  end)


-- Window Manager----
---------------------
local text2 = '<span color="' ..
    color.blueish_white .. '" font="Ubuntu Nerd Font 15">' .. '  :   ' .. 'awesome wm' .. '</span>'
local icon2 = '<span color="' .. color.yellow .. '" font="Ubuntu Nerd Font bold 16">' .. '' .. '</span>'

local wm_text = wibox.widget {
  {
    -- text = user.name,
    markup = icon2 .. text2,
    font = "Ubuntu Nerd Font Bold 14",
    widget = wibox.widget.textbox,
    fg = color.white,
    -- forced_width = dpi(300),
  },
  widget = wibox.container.margin,
  top = dpi(5),
  bottom = dpi(5),
  right = dpi(5),
  left = dpi(25),
  forced_height = dpi(40)
}

--Uptime----------
------------------
local uptime = 3

local text3 = '<span color="' ..
    color.blueish_white .. '" font="Ubuntu Nerd Font 15">' .. '  :   ' .. uptime .. '</span>'
local icon3 = '<span color="' .. color.green .. '" font="Ubuntu Nerd Font bold 16">' .. '󱎫' .. '</span>'

local uptime_textbox = wibox.widget {
  markup = icon3 .. text3,
  font = "Ubuntu Nerd Font Bold 14",
  widget = wibox.widget.textbox,
  fg = color.white,
}

local uptime_text = wibox.widget {
  uptime_textbox,
  widget = wibox.container.margin,
  top = dpi(5),
  bottom = dpi(5),
  right = dpi(5),
  left = dpi(25),
  forced_height = dpi(40)
}

awful.spawn.easy_async("uptime -p", function(out)
  uptime_textbox.markup = icon3 .. '<span color="' ..
      color.blueish_white .. '" font="Ubuntu Nerd Font 15">' .. '  :   ' .. out:gsub("up ", "") .. '</span>'
end)

local update_uptime = function()
  awful.spawn.easy_async("uptime -p", function(out)
    uptime_textbox.markup = icon3 .. '<span color="' ..
        color.blueish_white .. '" font="Ubuntu Nerd Font 15">' .. '  :   ' .. out:gsub("up ", "") .. '</span>'
  end)
end

local update_uptime_timer = gears.timer({
  timeout = 60,
  call_now = true,
  autostart = true,
  callback = update_uptime,
})


------------------------
--Main Widget-----------
------------------------
local profile = wibox.widget {
  {
    image,
    {
      {
        {
          {
            distro_text,
            wm_text,
            uptime_text,
            layout = wibox.layout.fixed.vertical
          },
          widget = wibox.container.margin,
          top = dpi(4),
          bottom = dpi(4),
          forced_width = dpi(410)
        },
        widget = wibox.container.background,
        bg = color.background_lighter,
        shape = function(cr, width, height)
          gears.shape.rounded_rect(cr, width, height, 10)
        end,

      },
      widget = wibox.container.margin,
      left = dpi(12)
    },
    layout = wibox.layout.fixed.horizontal
  },
  widget = wibox.container.margin,
  top = dpi(12),
  bottom = dpi(0),
  left = dpi(12),
  right = dpi(12),
  forced_width = dpi(430)
}

return profile
