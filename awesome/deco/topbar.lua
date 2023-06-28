-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Wibox handling library
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
mytextclock = wibox.widget.textclock('<span color="#ffffff" font="Roboto Bold 13"> %a %b %d, %H:%M </span>', 10)


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
    screen = s,
    taglist = { buttons = taglist_buttons },
    tasklist = { buttons = tasklist_buttons },
    -- taglist_buttons  = mytagbuttons,
    -- tasklist_buttons = tasklist_buttons,
    filter = awful.widget.taglist.filter.all,
  })
end)


-- the wibox
mywibox =
    awful.wibar({ position = "top", screen = s, height = 30, opacity = 0.7, fg = "#ffffff", bg = "#00000099" })

-- Add widgets to the wibox
mywibox:setup({
  layout = wibox.layout.stack,
  expand = "none",
  {
    layout = wibox.layout.align.horizontal,
    {
      -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      mytaglist,
      separator,
      mypromptbox,
      separator,
      separator,
      separator,
      separator,
      wibox.widget({
        image = "home/amitabha/.icons/papirus-icon-theme-20230301/Papirus/22x22/apps/launch.svg",
        resize_allowed = true,
        widget = wibox.widget.imagebox,
      }),
      -- s.mytasklist
    },
    nil,
    {
      -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      wibox.widget.systray(),
      separator,
      {
        id = "screenshot",
        widget = wibox.widget.imagebox,
        image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/ss.png",
        resize = true,
        opacity = 1,
      },
      separator,
      batteryarc_widget({
        show_current_level = true,
        arc_thickness = 2,
        size = 24,
        font = "CaskaydiaCove Nerd Font 9",
        margins = 55,
        timeout = 10,
      }),
      separator,
      -- button_control,
      separator,
      logout_menu_widget({
        font = "JetBrainsMono Nerd Font 14",
        onlock = function()
          awful.spawn.with_shell("i3lock-fancy")
        end,
      }),
      -- s.mylayoutbox,
    },
  },
  {
    mytextclock,
    valign = "center",
    halign = "center",
    layout = wibox.container.place,
  },
})

mywibox:get_children_by_id("screenshot")[1]:connect_signal("button::press", function()
  awful.spawn.with_shell(
    'scrot /tmp/screenshot.png && convert /tmp/screenshot.png -resize 20% /tmp/resized_screenshot.png && dunstify -i /tmp/resized_screenshot.png " " && cp /tmp/screenshot.png ~/Pictures/file1_`date +"%Y%m%d_%H%M%S"`.png && rm /tmp/resized_screenshot.png && rm /tmp/screenshot.png'
  )
end)
