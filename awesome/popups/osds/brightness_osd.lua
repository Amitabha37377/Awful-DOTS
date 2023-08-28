local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Color
local color = require("popups.color")

local Separator = wibox.widget.textbox("   ")
Separator.forced_height = dpi(300)
Separator.forced_width = dpi(300)

---------------------------
--Volume Icon Image--------
---------------------------

local image = wibox.widget {
  image = os.getenv("HOME") .. '/.config/awesome/popups/osds/assets/brightness2.png',
  widget = wibox.widget.imagebox,
  resize = true,
  forced_height = dpi(200),
  forced_width = dpi(200),
  halign = 'center'
}

----------------------------
--Slider--------------------
----------------------------

local brightness_slider = wibox.widget({
  widget = wibox.widget.slider,
  bar_shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 15)
  end,
  bar_height = dpi(15),
  bar_color = color.white,
  bar_active_color = color.blue,
  handle_shape = gears.shape.circle,
  handle_color = "#4682b8",
  handle_width = dpi(15),
  handle_border_width = 1,
  handle_border_color = "#4682b8",
  minimum = 5,
  maximum = 100,
  value = 69
})

--FUnctionality of Brightness Slider
brightness_slider:connect_signal("property::value", function(slider)
  local brightness_level = math.floor(slider.value / 100 * 100)
  awful.spawn.easy_async("light -S " .. brightness_level, function()
  end)
end)

----------------------------
--Volume Text Box-----------
----------------------------
local brightness_text = wibox.widget {
  markup = '<span color="' .. color.blueish_white .. '" font="Ubuntu Nerd Font bold 12">' .. 'Brightness' .. '</span>'
  ,
  widget = wibox.widget.textbox,
  fg = color.white,
}

local brightness_percentage = wibox.widget {
  markup = '<span color="' ..
      color.blueish_white .. '" font="Ubuntu Nerd Font bold 12">' .. brightness_slider.value .. '</span>'
  ,
  widget = wibox.widget.textbox,
  fg = color.white,
}

--Update brightness value
local update_brightness_slider = function()
  awful.spawn.easy_async("light -G", function(stdout)
    local brightness = tonumber(stdout)
    brightness_slider.value = brightness
    brightness_percentage.markup = '<span color="' ..
        color.blueish_white .. '" font="Ubuntu Nerd Font bold 12">' .. brightness_slider.value .. '</span>'
  end)
end

local brightness_slider_timer = gears.timer({
  timeout = 1,
  call_now = true,
  autostart = true,
  callback = update_brightness_slider,
})

----------------------------
--Main Osd popup box--------
----------------------------

local osd_box = awful.popup {
  screen = s,
  widget = wibox.container.background,
  ontop = true,
  bg = "#00000000",
  visible = false,
  placement = function(c)
    awful.placement.bottom(c,
      { margins = { top = dpi(8), bottom = dpi(80), left = 0, right = 0 } })
  end,
  opacity = 1
}

osd_box:setup {
  {
    {
      {
        image,
        widget = wibox.container.margin,
        top = dpi(15),
        bottom = dpi(0),
        right = dpi(50),
        left = dpi(50)
      },
      {
        {
          brightness_text,
          nil,
          brightness_percentage,
          layout = wibox.layout.align.horizontal
        },
        widget = wibox.container.margin,
        left = dpi(25),
        right = dpi(27),
        top = dpi(0),
        bottom = dpi(15)
      },
      {
        brightness_slider,
        widget = wibox.container.margin,
        bottom = dpi(15),
        top = dpi(0),
        left = dpi(25),
        right = dpi(25),
        forced_height = dpi(30),
        forced_width = dpi(270)
      },
      widget = wibox.container.place,
      halign = 'center',
      layout = wibox.layout.fixed.vertical
    },
    Separator,
    layout = wibox.layout.stack
  },
  widget = wibox.container.background,
  bg = color.background_dark,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 15)
  end,
}

return osd_box
