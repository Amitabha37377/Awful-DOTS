--Standard Modules
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local color = require("layout.topbar.colors")
local dpi = beautiful.xresources.apply_dpi

local separator = wibox.widget.textbox("   ")
local separator2 = wibox.widget.textbox("    ")

local ss_tool = require("popups.screen_record.screenshot.main")

--Popup Menus
local control = require("popups.control_center.main")
local notif_center = require("popups.notif_center.main")
local media = require("popups.media_player.main")

--Battery Widget
local batteryarc_widget = require("deco.batteryarc")

local screenshot_image = wibox.widget {
  widget = wibox.widget.imagebox,
  image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/screenshot.png",
  resize = true,
  opacity = 1,
}

--Screenshot button
local screenshot = wibox.widget {
  {
    screenshot_image,
    left   = dpi(6),
    right  = dpi(6),
    top    = dpi(6),
    bottom = dpi(6),
    widget = wibox.container.margin
  },
  bg = color.background_lighter,
  shape = gears.shape.rounded_rect,
  widget = wibox.container.background,
}

screenshot:connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    -- awful.spawn.with_shell(
    --   'scrot /tmp/screenshot.png && convert /tmp/screenshot.png -resize 20% /tmp/resized_screenshot.png && dunstify -i /tmp/resized_screenshot.png "Screenshot Captured" && cp /tmp/screenshot.png ~/Pictures/file1_`date +"%Y%m%d_%H%M%S"`.png && rm /tmp/resized_screenshot.png && rm /tmp/screenshot.png'
    -- )
    ss_tool.visible = not ss_tool.visible
  elseif button == 3 then
    awful.spawn.with_shell(
      'scrot /tmp/screenshot.png && convert /tmp/screenshot.png -resize 20% /tmp/resized_screenshot.png && dunstify -i /tmp/resized_screenshot.png "Screenshot Captured" && cp /tmp/screenshot.png ~/Pictures/file1_`date +"%Y%m%d_%H%M%S"`.png && rm /tmp/resized_screenshot.png && rm /tmp/screenshot.png'
    )
  end
end)

-- screenshot:connect_signal("mouse::enter", function()
--   screenshot_image.image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/screenshot-hover.png"
-- end)
--
-- screenshot:connect_signal("mouse::leave", function()
--   screenshot_image.image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/screenshot.png"
-- end)
--
-- screenshot:connect_signal("button::press", function()
--   screenshot_image.image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/screenshot-click.png"
-- end)
--
-- screenshot:connect_signal("button::release", function()
--   screenshot_image.image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/screenshot-hover.png"
-- end)


local settings_image = wibox.widget {
  widget = wibox.widget.imagebox,
  image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/settings.png",
  resize = true,
  opacity = 1,
}

local settings = wibox.widget {
  {
    settings_image,
    left   = dpi(5),
    right  = dpi(5),
    top    = dpi(5),
    bottom = dpi(5),
    widget = wibox.container.margin
  },
  bg = color.background_lighter,
  shape = gears.shape.rounded_rect,
  widget = wibox.container.background,
}

settings:connect_signal("button::release", function()
  control.visible = not control.visible
  notif_center.visible = false
  media.visible = false
end)

-- settings:connect_signal("mouse::enter", function()
--   settings_image.image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/settings-hover.png"
-- end)
--
-- settings:connect_signal("mouse::leave", function()
--   settings_image.image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/settings.png"
-- end)
--
-- settings:connect_signal("button::press", function()
--   settings_image.image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/settings-click.png"
-- end)
--
-- settings:connect_signal("button::release", function()
--   settings_image.image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/settings-hover.png"
-- end)



music_image = wibox.widget {
  widget = wibox.widget.imagebox,
  image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/music-icon.png",
  resize = true,
  opacity = 1,
}


local music = wibox.widget {
  {
    music_image,
    left   = dpi(5),
    right  = dpi(5),
    top    = dpi(5),
    bottom = dpi(5),
    widget = wibox.container.margin
  },
  bg = color.background_lighter,
  shape = gears.shape.rounded_rect,
  widget = wibox.container.background,
}

music:connect_signal("button::release", function()
  media.visible = not media.visible
  control.visible = false
end)

-- music:connect_signal("mouse::enter", function()
--   music_image.image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/music-icon-hover.png"
-- end)
--
-- music:connect_signal("mouse::leave", function()
--   music_image.image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/music-icon.png"
-- end)
--
-- music:connect_signal("button::press", function()
--   music_image.image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/music-icon-click.png"
-- end)
--
-- music:connect_signal("button::release", function()
--   music_image.image = os.getenv("HOME") .. "/.config/awesome/layout/topbar/icons/music-icon-hover.png"
-- end)



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
    bg     = color.background_lighter
  },
  left   = dpi(3),
  right  = dpi(3),
  top    = dpi(3),
  bottom = dpi(3),
  widget = wibox.container.margin

}

return system_tray
