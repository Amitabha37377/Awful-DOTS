--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")

--Custom Modules
local user = require("popups.user_profile")
local color = require("popups.color")

--Separator
local Separator = wibox.widget.textbox("    ")
Separator.forced_height = dpi(4)

--Conatiners
local wifi = require("popups.control_center.buttons.containers.wifi")
local bluetooth = require("popups.control_center.buttons.containers.bluetooth")
local dnd = require("popups.control_center.buttons.containers.dnd")


--Wifi button functionality
local wifi_on = true

wifi:connect_signal("button::press", function()
  wifi_on = not wifi_on
  if wifi_on then
    wifi:set_bg(color.blue)
    os.execute("nmcli radio wifi on")
  else
    wifi:set_bg(color.grey)
    os.execute("nmcli radio wifi off")
  end
end)


-----------------------------------------
--Wifi Button
-----------------------------------------
local wifi_status = wibox.widget {
  -- text = user.name,
  markup = '<span color="' .. color.white .. '" font="Ubuntu Nerd Font 11">' .. "on" .. '</span>',
  font = "Ubuntu Nerd Font Bold 14",
  widget = wibox.widget.textbox,
  fg = color.white
}

--text
local text_wifi = wibox.widget {
  {
    {
      -- text = user.name,
      markup = '<span color="' .. color.blueish_white .. '" font="Ubuntu Nerd Font bold 11">' .. "Wifi" .. '</span>',
      font = "Ubuntu Nerd Font Bold 14",
      widget = wibox.widget.textbox,
      fg = color.white
    },
    Separator,
    wifi_status,
    layout = wibox.layout.fixed.vertical,
    id = "wifi",
  },
  widget = wibox.container.margin,
  top = dpi(8),
  bottom = dpi(8),
  right = dpi(8),
  left = dpi(8),
  forced_height = dpi(56),
  id = "wifi_margin",
}

--UserImage
local image_wifi = wibox.widget {
  wifi,
  widget = wibox.container.margin,
  top = 3,
  bottom = 3,
  right = 10,
  left = 7,
  forced_height = dpi(56)
}


--Wifi button functionality
local wifi_on = true

wifi:connect_signal("button::press", function()
  wifi_on = not wifi_on
  if wifi_on then
    wifi:set_bg(color.blue)
    wifi_status:set_markup_silently('<span color="' ..
      color.white .. '" font="Ubuntu Nerd Font 11">' .. "on" .. '</span>')
    os.execute("nmcli radio wifi on")
  else
    wifi:set_bg(color.grey)
    os.execute("nmcli radio wifi off")
    wifi_status:set_markup_silently('<span color="' ..
      color.white .. '" font="Ubuntu Nerd Font 11">' .. "off" .. '</span>')
  end
end)



-----------------------------------------
--Bluetooth Button
-----------------------------------------
local bluetooth_status = wibox.widget {
  -- text = user.name,
  markup = '<span color="' .. color.white .. '" font="Ubuntu Nerd Font 11">' .. "off" .. '</span>',
  font = "Ubuntu Nerd Font Bold 14",
  widget = wibox.widget.textbox,
  fg = color.white
}

--text
local text_bluetooth = wibox.widget {
  {
    {
      -- text= user.name,
      markup = '<span color="' .. color.blueish_white .. '" font="Ubuntu Nerd Font bold 11">' .. "Bluetooth" .. '</span>',
      font = "Ubuntu Nerd Font Bold 14",
      widget = wibox.widget.textbox,
      fg = color.white
    },
    Separator,
    bluetooth_status,
    layout = wibox.layout.fixed.vertical

  },
  widget = wibox.container.margin,
  top = dpi(6),
  bottom = dpi(8),
  right = dpi(8),
  left = dpi(8),
  forced_height = dpi(56)
}

--UserImage
local image_bluetooth = wibox.widget {
  bluetooth,
  widget = wibox.container.margin,
  top = 3,
  bottom = 3,
  right = 10,
  left = 7,
  forced_height = dpi(56)
}

--Button Functionality
local bluetooth_on = false

bluetooth:connect_signal("button::press", function()
  bluetooth_on = not bluetooth_on
  if bluetooth_on then
    bluetooth:set_bg(color.magenta)
    bluetooth_status:set_markup_silently('<span color="' ..
      color.white .. '" font="Ubuntu Nerd Font 11">' .. "on" .. '</span>')
  else
    bluetooth:set_bg(color.grey)
    bluetooth_status:set_markup_silently('<span color="' ..
      color.white .. '" font="Ubuntu Nerd Font 11">' .. "off" .. '</span>')
  end
end)

---------------------------------------
--Do not Disturb-----------------------
----------------------------------------

local dnd_status = wibox.widget {
  -- text = user.name,
  markup = '<span color="' .. color.white .. '" font="Ubuntu Nerd Font 11">' .. "off" .. '</span>',
  font = "Ubuntu Nerd Font Bold 14",
  widget = wibox.widget.textbox,
  fg = color.white
}

--text
local text_dnd = wibox.widget {
  {
    {
      -- text = user.name,
      markup = '<span color="' ..
          color.blueish_white .. '" font="Ubuntu Nerd Font bold 11">' .. "DND" .. '</span>',
      font = "Ubuntu Nerd Font Bold 14",
      widget = wibox.widget.textbox,
      fg = color.white
    },
    Separator,
    dnd_status,
    layout = wibox.layout.fixed.vertical

  },
  widget = wibox.container.margin,
  top = dpi(6),
  bottom = dpi(8),
  right = dpi(8),
  left = dpi(8),
  forced_height = dpi(56)
}

--UserImage
local image_dnd = wibox.widget {
  dnd,
  widget = wibox.container.margin,
  top = dpi(3),
  bottom = dpi(3),
  right = dpi(10),
  left = dpi(7),
  forced_height = dpi(56)
}


--Button Functionality
local dnd_on = false

dnd:connect_signal("button::press", function()
  dnd_on = not dnd_on
  if dnd_on then
    dnd:set_bg(color.yellow)
    dnd_status:set_markup_silently('<span color="' ..
      color.white .. '" font="Ubuntu Nerd Font 11">' .. "on" .. '</span>')
    user.dnd_status = true
  else
    dnd:set_bg(color.grey)
    dnd_status:set_markup_silently('<span color="' ..
      color.white .. '" font="Ubuntu Nerd Font 11">' .. "off" .. '</span>')
    user.dnd_status = false
  end
end)

if dnd_on then
  naughty.destroy_all_notifications(nil, 1)
end

--------------------------------
--Final container
--------------------------------

--Main Widget
local button = wibox.widget {
  {
    {
      {
        {
          image_wifi,
          text_wifi,
          layout = wibox.layout.fixed.horizontal,
        },
        widget = wibox.container.margin,
        top = dpi(6),
        bottom = dpi(3),
        left = dpi(2),
        right = 0,
      },
      {
        {
          image_bluetooth,
          text_bluetooth,
          layout = wibox.layout.fixed.horizontal,
        },
        widget = wibox.container.margin,
        top = dpi(3),
        bottom = dpi(3),
        left = dpi(2),
        right = 0,
      },
      {
        {
          image_dnd,
          text_dnd,
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
