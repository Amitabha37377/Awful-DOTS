local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local color = require("popups.color")
local text = require("popups.powermenu.text")

--Buttons
local shutdown = require("popups.powermenu.buttons.shutdown")
local reboot = require("popups.powermenu.buttons.reboot")
local logout = require("popups.powermenu.buttons.logout")
local lock = require("popups.powermenu.buttons.lock")
local sleep = require("popups.powermenu.buttons.sleep")


--Separator widget
local Separator = wibox.widget.textbox("    ")
Separator.forced_height = dpi(1080)
Separator.forced_width = dpi(1920)

local Separator2 = wibox.widget.textbox("    ")
Separator2.forced_width = dpi(90)

--Main powermenu wibox

local powermenu = awful.popup {
  screen = s,
  widget = wibox.container.background,
  ontop = true,
  bg = "#00000000",
  visible = false,
  placement = function(c)
    awful.placement.centered(c,
      { margins = { top = dpi(0), bottom = dpi(0), left = dpi(0), right = dpi(0) } })
  end,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 0)
  end,
  opacity = 1,
  forced_height = dpi(1080),
  forced_width = dpi(1920),
}

powermenu:setup {
  {
    Separator,
    {
      {
        {
          shutdown,
          Separator2,
          reboot,
          Separator2,
          logout,
          Separator2,
          sleep,
          Separator2,
          lock,
          layout = wibox.layout.fixed.horizontal
        },
        {
          text,
          widget = wibox.container.margin,
          top = 40,
        },
        layout = wibox.layout.fixed.vertical
      },
      layout = wibox.container.place
    },
    layout = wibox.layout.stack
  },
  widget = wibox.container.background,
  bg = color.background_lighter2 .. "60"
}

powermenu:connect_signal("button::press", function(_, _, _, button)
  if button == 3 then
    awesome.emit_signal("widget::control")
    powermenu.visible = false
  end
end)

awesome.connect_signal("widget::powermenu", function()
  powermenu.visible = false
end)

awesome.connect_signal("widget::powermenu2", function()
  powermenu.visible = true
end)

return powermenu
