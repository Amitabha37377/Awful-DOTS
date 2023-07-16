local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local color = require("popups.color")

--Image widget
local image = wibox.widget {
  widget = wibox.widget.imagebox,
  image = os.getenv("HOME") .. "/.config/awesome/popups/powermenu/assets/lock.png",
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
  button.border_color = color.green
  image.image = os.getenv("HOME") .. "/.config/awesome/popups/powermenu/assets/lock-hover.png"
end)
--
button:connect_signal("mouse::leave", function()
  button.border_color = color.grey
  image.image = os.getenv("HOME") .. "/.config/awesome/popups/powermenu/assets/lock.png"
end)


-- --Open app on click
-- button:connect_signal("button::press", function(_, _, _, button)
--   if button == 1 then
--     awful.spawn.with_shell("telegram-desktop")
--   end
-- end)
--

-- --Hover highlight effects
-- button:connect_signal("mouse::enter", function()
--   button.bg = color.background_lighter
-- end)
--
-- button:connect_signal("mouse::leave", function()
--   button.bg = color.background_dark
-- end)
--
-- button:connect_signal("button::press", function()
--   button.bg = color.background_morelight
-- end)
--
-- button:connect_signal("button::release", function()
--   button.bg = color.background_lighter
-- end)
--

return button
