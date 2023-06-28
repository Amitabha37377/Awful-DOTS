-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")


-- Custom Local Library: Common Functional Decoration
local deco = {
  wallpaper = require("deco.wallpaper"),
  taglist = require("deco.taglist"),
  tasklist = require("deco.tasklist"),
}

local taglist_buttons = deco.taglist()
local tasklist_buttons = deco.tasklist()

local _M = {}

--Spacer
local separator = wibox.widget.textbox("     ")

local battery_widget = require("deco.battery")
local calendar_widget = require("deco.calendar")
local batteryarc_widget = require("deco.batteryarc")
local logout_menu_widget = require("deco.logout-menu")


---------------------------
--Widgets------------------
---------------------------

--textclock widget
mytextclock = wibox.widget.textclock('<span color="#A9B1D6" font="Ubuntu Nerd Font Bold 13"> %a %b %d, %H:%M </span>', 10)


--calendar-widget
local cw = calendar_widget({
  theme = "outrun",
  placement = "top_center",
  start_sunday = true,
  radius = 8,
  previous_month_button = 1,
  next_month_button = 3,
})
mytextclock:connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    cw.toggle()
  end
end)


--Fancy taglist widget
awful.screen.connect_for_each_screen(function(s)
  local fancy_taglist = require("fancy_taglist")
  mytaglist = fancy_taglist.new({
    screen   = s,
    taglist  = { buttons = taglist_buttons },
    tasklist = { buttons = tasklist_buttons },
    filter   = awful.widget.taglist.filter.all,
    style    = {
      shape = gears.shape.rounded_rect
    },
  })
end)

--Taglist widget
local fancy_taglist = wibox.widget {
  {
    mytaglist,
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

local awesome_logo = require("layout.topbar.awesome_logo")
local power_button = require("layout.topbar.power_button")
local top_left = require("layout.topbar.top_left")
local systray = require("layout.topbar.systray")

-------------------------------------------
-- the wibar
-------------------------------------------

mywibox =
    awful.wibar({
      position = "top",
      margins = { top = 7, left = 8, right = 8, bottom = 0 },
      screen = s,
      height = 35,
      opacity = 1,
      fg = "#89B4FA",
      bg = "#1A1B26",
      shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 8)
      end,

    })

--Main Wibar
mywibox:setup({
  layout = wibox.layout.stack,
  expand = "none",
  {
    layout = wibox.layout.align.horizontal,
    {
      -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      separator,
      awesome_logo,
      separator,
      fancy_taglist,
      mypromptbox,
      wibox.widget({
        image = "home/amitabha/.icons/papirus-icon-theme-20230301/Papirus/22x22/apps/launch.svg",
        resize_allowed = true,
        widget = wibox.widget.imagebox,
      }),
    },
    nil,
    {
      -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      systray,
      separator,
      top_left,
      separator,
      batteryarc_widget({
        show_current_level = true,
        arc_thickness = 3,
        size = 26,
        font = "CaskaydiaCove Nerd Font 10",
        margins = 55,
        timeout = 10,
      }),

      separator,
    },
  },
  {
    mytextclock,
    valign = "center",
    halign = "center",
    layout = wibox.container.place,
  },
})
