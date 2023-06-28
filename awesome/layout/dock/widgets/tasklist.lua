--Standard Modules
local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")

--color and icons
local color = require("layout.dock.color")
local icon_path = require("layout.dock.icon_path")

-- tasklist buttons
local deco = {
  wallpaper = require("deco.wallpaper"),
  taglist = require("deco.taglist"),
  tasklist = require("deco.tasklist"),
}

local taglist_buttons = deco.taglist()
local tasklist_buttons = deco.tasklist()


--Tasklist Popup box
local popup = awful.popup({
  widget = awful.widget.tasklist({
    screen = screen[1],
    filter = awful.widget.tasklist.filter.allscreen,
    buttons = tasklist_buttons,
    margins = {
      top = 10,
      bottom = 10,
      left = 10,
      right = 10,
    },
    style = {
      shape = gears.shape.rounded_rect,
    },
    layout = {
      margins = 5,
      spacing = 5,
      forced_num_rows = 2,
      layout = wibox.layout.grid.horizontal,
    },
    widget_template = {
      {
        {
          id = "clienticon",
          widget = awful.widget.clienticon,
          margins = 4,
          resize = false,
        },
        margins = 4,
        widget = wibox.container.margin,
      },
      id = "background_role",
      forced_width = 58,
      forced_height = 58,
      widget = wibox.container.background,
      create_callback = function(self, c, index, objects) --luacheck: no unused
        self:get_children_by_id("clienticon")[1].client = c
      end,
    },
  }),
  bg = "#1a1b26",
  border_color = "#1a1b26",
  border_width = 10,
  ontop = true,
  -- placement    = awful.placement.bottom_left + awful.placement.no_offscreen,
  placement = function(c)
    local screen_geometry = awful.screen.focused().geometry
    return awful.placement.bottom(c, { margins = { bottom = 75, left = 800 } })
  end,
  geometry = { x = 10, y = -10 },
  shape = gears.shape.rounded_rect,
  visible = false,
})

--Button to open the popup box
local button = wibox.widget {
  {
    {
      widget = wibox.widget.imagebox,
      image = os.getenv("HOME") .. "/.icons/papirus-icon-theme-20230301/Papirus/48x48/apps/appimagekit-dockstation.svg",
      resize = true,
      opacity = 1,
    },
    left   = 1.1,
    right  = 1.1,
    top    = 1.1,
    bottom = 1.1,
    widget = wibox.container.margin
  },
  bg = color.background_dark,
  shape = gears.shape.rounded_rect,
  widget = wibox.container.background,
  forced_height = 48,
  forced_width = 48,
}

--Hover highlight effects
button:connect_signal("mouse::enter", function()
  button.bg = color.background_lighter
end)

button:connect_signal("mouse::leave", function()
  button.bg = color.background_dark
end)

button:connect_signal("button::press", function()
  button.bg = color.background_morelight
end)

button:connect_signal("button::release", function()
  button.bg = color.background_lighter
end)

--Open popup box on click
button:connect_signal("button::release", function()
  popup.visible = not popup.visible
end)

return button
