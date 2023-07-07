local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Color
local color = require("layout.dock.color")

--Apps
local Item1 = require("layout.dock.apps.launcher")
local Item2 = require("layout.dock.apps.firefox")
local Item3 = require("layout.dock.apps.kitty")
local Item4 = require("layout.dock.apps.vs_code")
local Item5 = require("layout.dock.apps.gimp")
local Item6 = require("layout.dock.apps.telegram")
local Item7 = require("layout.dock.apps.discord")
local Item8 = require("layout.dock.apps.blender")
local Item9 = require("layout.dock.apps.unity")
local Item10 = require("layout.dock.apps.onlyoffice")
local Item11 = require("layout.dock.apps.android_studio")

--Directories
local home = require("layout.dock.directories.home")
local downloads = require("layout.dock.directories.downloads")
local documents = require("layout.dock.directories.documents")
local config = require("layout.dock.directories.config")

--Widgets
local task_popup = require("layout.dock.widgets.tasklist")
local layoutbox = require("layout.dock.widgets.layout_switcher")

--Separator line
local vertical_separator = wibox.widget {
  orientation = 'vertical',
  forced_height = dpi(1.5),
  forced_width = dpi(1.5),
  span_ratio = 0.55,
  widget = wibox.widget.separator,
  color = "#a9b1d6",
  border_color = "#a9b1d6",
  opacity = 0.55
}

--Separator
local Separator = wibox.widget.textbox("   ")
Separator.forced_height = dpi(60)

local Separator2 = wibox.widget.textbox(" ")

--Main dock
local dock = awful.popup {
  screen = s,
  widget = wibox.container.background,
  ontop = false,
  -- bg = color.background_dark,
  bg = "#00000000",
  visible = true,
  -- maximum_width = 200,
  maximum_height = dpi(60),
  -- maximum_width = 900,
  placement = function(c)
    awful.placement.bottom(c,
      { margins = { top = dpi(8), bottom = dpi(5), left = 0, right = 0 } })
  end,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 15)
  end,
  opacity = 0
}

-- dock:struts {
--   bottom = 64
-- }

dock:setup {
  {
    Separator2,
    Separator2,
    Separator2,
    Separator,
    {
      Item1,
      layout = wibox.container.place
    },
    Separator,
    vertical_separator,
    Separator,
    {
      Item2,
      layout = wibox.container.place
    },
    Separator,
    {
      Item3,
      layout = wibox.container.place
    },
    Separator,
    {
      Item4,
      layout = wibox.container.place
    },
    Separator,
    {
      Item5,
      layout = wibox.container.place
    },
    Separator,
    {
      Item6,
      layout = wibox.container.place
    },
    Separator,
    {
      Item7,
      layout = wibox.container.place
    },
    Separator,
    {
      Item8,
      layout = wibox.container.place
    },
    Separator,
    {
      Item9,
      layout = wibox.container.place
    },
    Separator,
    {
      Item10,
      layout = wibox.container.place
    },
    Separator,

    {
      Item11,
      layout = wibox.container.place
    },

    Separator,
    vertical_separator,
    Separator,

    {
      home,
      layout = wibox.container.place
    },
    Separator,

    {
      downloads,
      layout = wibox.container.place
    },
    Separator,
    {
      documents,
      layout = wibox.container.place
    },

    Separator,
    {
      config,
      layout = wibox.container.place,
    },
    Separator,
    vertical_separator,
    Separator,

    {
      task_popup,
      layout = wibox.container.place,
    },
    Separator,

    {
      layoutbox,
      layout = wibox.container.place,
    },
    Separator,
    Separator2,

    layout = wibox.layout.fixed.horizontal,
  },
  widget = wibox.container.background,
  bg = color.background_dark,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 15)
  end,
}

--Autohide Dock when main dock is not visible

local function hide_wibox()
  dock.ontop = false
  dock.opacity = 0
end

local function show_wibox()
  dock.ontop = true
  dock.opacity = 1
end

-- Time to wait before dock disappears again
local timeout_duration = 1

-- timer
local timer = gears.timer {
  timeout = timeout_duration,
  autostart = true,
  callback = hide_wibox
}

-- Attach the timer to a signal that triggers when the mouse enters the dock
dock:connect_signal("mouse::enter", function()
  timer:stop() -- Stop the timer when the mouse enters the dock
  show_wibox() -- Show the dock immediately
end)

-- Attach the timer to a signal that triggers when the mouse leaves the dock
dock:connect_signal("mouse::leave", function()
  timer:again() -- Restart the timer when the mouse leaves the dock
end)
