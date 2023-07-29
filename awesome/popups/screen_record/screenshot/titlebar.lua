local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local color = require("popups.color")


--Screenshot header
local ss_text = wibox.widget { {
  {
    -- text = user.name,
    markup = '<span color="' ..
        color.background_dark .. '" font="Ubuntu Nerd Font Bold 15">' .. "󰄄 Screenshot" .. '</span>',
    font = "Ubuntu Nerd Font Bold 14",
    widget = wibox.widget.textbox,
    fg = color.white
  },
  widget = wibox.container.margin,
  top = dpi(5),
  bottom = dpi(5),
  right = dpi(5),
  left = dpi(7),
},
  widget = wibox.container.background,
  bg = color.magenta,
  forced_width = dpi(190),
  forced_height = dpi(36),
  shape = function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, 5)
  end,

}

--Screenreconrd header
local sr_text = wibox.widget { {
  {
    -- text = user.name,
    markup = '<span color="' ..
        color.blueish_white .. '" font="Ubuntu Nerd Font Bold 15">' .. "  Screen record" .. '</span>',
    font = "Ubuntu Nerd Font Bold 14",
    widget = wibox.widget.textbox,
    fg = color.white
  },
  widget = wibox.container.margin,
  top = dpi(5),
  bottom = dpi(5),
  right = dpi(5),
  left = dpi(9),
},
  widget = wibox.container.background,
  bg = color.background_lighter2,
  forced_width = dpi(190),
  forced_height = dpi(36),
  shape = function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, false, true, true, false, 5)
  end,

}

local close = wibox.widget {
  markup = '<span color="' ..
      "#df5b61" .. '" font="Ubuntu Nerd Font bold 23">' .. "  󰅙" .. '</span>',
  font = "Ubuntu Nerd Font Bold 14",
  widget = wibox.widget.textbox,
  fg = color.white

}


--Main titlebar
local titlebar = wibox.widget {
  {
    {
      {
        ss_text,
        -- sr_text,
        layout = wibox.layout.fixed.horizontal
      },
      widget = wibox.container.margin,
      top = dpi(9),
      bottom = dpi(9),
      left = dpi(19),
      right = dpi(3)
    },
    {
      close,
      widget = wibox.container.margin,
      top = dpi(0),
      bottom = dpi(0),
      right = dpi(0),
      left = dpi(87 + 180)
    },
    layout = wibox.layout.fixed.horizontal
  },
  widget = wibox.container.background,
  bg = color.background_lighter,
  forced_width = dpi(540)
}

--Hover effects on close button
close:connect_signal("mouse::enter", function()
  close:set_markup_silently('<span color="' ..
    "#e36f84" .. '" font="Ubuntu Nerd Font bold 23">' .. "  󰅙" .. '</span>')
end)

close:connect_signal("mouse::leave", function()
  close:set_markup_silently('<span color="' ..
    "#df5b61" .. '" font="Ubuntu Nerd Font bold 23">' .. "  󰅙" .. '</span>')
end)

close:connect_signal("button::press", function()
  close:set_markup_silently('<span color="' ..
    color.red .. '" font="Ubuntu Nerd Font bold 23">' .. "  󰅙" .. '</span>')
end)

close:connect_signal("button::release", function()
  close:set_markup_silently('<span color="' ..
    "#e36f84" .. '" font="Ubuntu Nerd Font bold 23">' .. "  󰅙" .. '</span>')
end)



close:connect_signal("button::release", function(_, _, _, button)
  if button == 1 then
    awesome.emit_signal("widget::screenshot")
  end
end)


return titlebar
