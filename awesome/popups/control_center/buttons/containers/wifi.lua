local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Custom Modules
local user = require("popups.user_profile")
local color = require("popups.color")



local wifi = wibox.widget {
  {
    {
      image = os.getenv("HOME") .. "/.config/awesome/popups/control_center/assets/wifi.png",
      widget = wibox.widget.imagebox,
      resize = true,
      shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 20)
      end,

    },
    widget = wibox.container.margin,
    top = dpi(15),
    bottom = dpi(15),
    left = dpi(14),
    right = dpi(13),
  },
  widget = wibox.container.background,
  bg = color.blue,
  shape = function(cr, width, height)
    gears.shape.rounded_bar(cr, dpi(52), dpi(50))
  end
}

--Button functionality

-- local wifi_on = true
--
-- wifi:connect_signal("button::press", function()
--   wifi_on = not wifi_on
--   if wifi_on then
--     wifi:set_bg(color.blue)
--     os.execute("nmcli radio wifi on")
--   else
--     wifi:set_bg(color.grey)
--     os.execute("nmcli radio wifi off")
--   end
-- end)
--

return wifi
