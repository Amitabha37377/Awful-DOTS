local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local color = require("popups.color")
local text = require("popups.powermenu.text")

--Image widget
local image = wibox.widget {
  widget = wibox.widget.imagebox,
  image = os.getenv("HOME") .. "/.config/awesome/popups/powermenu/assets/power.png",
  resize = true,
  opacity = 1,

}

--Main Widget
local button = wibox.widget {
  {
    image,
    left   = dpi(35),
    right  = dpi(35),
    top    = dpi(35),
    bottom = dpi(35),
    widget = wibox.container.margin
  },
  bg = color.background_dark,
  shape = gears.shape.rounded_rect,
  widget = wibox.container.background,
  forced_height = dpi(150),
  forced_width = dpi(150),
  border_width = dpi(5),
  border_color = color.grey
}

button:connect_signal("mouse::enter", function()
  button.border_color = color.red
  image.image = os.getenv("HOME") .. "/.config/awesome/popups/powermenu/assets/power-hover.png"
  text:set_markup_silently('<span color="' ..
    color.red .. '" font="Ubuntu Nerd Font bold 28">' .. "Power Off" .. '</span>')
end)
--
button:connect_signal("mouse::leave", function()
  button.border_color = color.grey
  image.image = os.getenv("HOME") .. "/.config/awesome/popups/powermenu/assets/power.png"
  text:set_markup_silently('<span color="' ..
    color.white .. '" font="Ubuntu Nerd Font 28">' .. " " .. '</span>')
end)

button:connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    awesome.emit_signal("widget::powermenu")
    awful.spawn("shutdown -h now")
  end
end)

return button
