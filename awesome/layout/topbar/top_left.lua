--Standard Modules
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")

local separator = wibox.widget.textbox("   ")
local separator2 = wibox.widget.textbox("    ")


--Battery Widget
local batteryarc_widget = require("deco.batteryarc")

--Screenshot button
local screenshot = wibox.widget {
  {
    {
      widget = wibox.widget.imagebox,
      image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/screenshot.png",
      resize = true,
      opacity = 1,
    },
    left   = 6,
    right  = 6,
    top    = 6,
    bottom = 6,
    widget = wibox.container.margin
  },
  bg = "1A1B26",
  shape = gears.shape.rounded_rect,
  widget = wibox.container.background,
}

screenshot:connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    awful.spawn.with_shell(
      'scrot /tmp/screenshot.png && convert /tmp/screenshot.png -resize 20% /tmp/resized_screenshot.png && dunstify -i /tmp/resized_screenshot.png " " && cp /tmp/screenshot.png ~/Pictures/file1_`date +"%Y%m%d_%H%M%S"`.png && rm /tmp/resized_screenshot.png && rm /tmp/screenshot.png'
    )
  end
end)


local settings = wibox.widget {
  {
    {
      widget = wibox.widget.imagebox,
      image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/settings.png",
      resize = true,
      opacity = 1,
    },
    left   = 5,
    right  = 5,
    top    = 5,
    bottom = 5,
    widget = wibox.container.margin
  },
  bg = "1A1B26",
  shape = gears.shape.rounded_rect,
  widget = wibox.container.background,
}

local music = wibox.widget {
  {
    {
      widget = wibox.widget.imagebox,
      image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/music-icon.png",
      resize = true,
      opacity = 1,
    },
    left   = 5,
    right  = 5,
    top    = 5,
    bottom = 5,
    widget = wibox.container.margin
  },
  bg = "1A1B26",
  shape = gears.shape.rounded_rect,
  widget = wibox.container.background,
}

--Main Window
local system_tray = wibox.widget {
  {
    {
      separator,
      music,
      separator,
      settings,
      separator,
      screenshot,
      separator,

      layout = wibox.layout.fixed.horizontal,
    },
    widget = wibox.container.background,
    shape  = gears.shape.rounded_rect,
    bg     = "#24283b"
  },
  left   = 3,
  right  = 3,
  top    = 3,
  bottom = 3,
  widget = wibox.container.margin

}

return system_tray
