-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Menubar library
local menubar = require("menubar")

-- Resource Configuration
local modkey = RC.vars.modkey
local terminal = RC.vars.terminal

--Custom Widgets
local dock = require("layout.dock.dock")
local control_center = require("popups.control_center.main")
local powermenu = require("popups.powermenu.main")

local _M = {}


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
  local globalkeys = gears.table.join(

  -- Open List of keyboard shortcuts

    awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
    awful.key {
      modifiers   = { modkey },
      key         = 'j',
      description = 'focus next by index',
      group       = 'client',
      on_press    = function()
        awful.client.focus.byidx(1)
      end,
    },

    ----------------------------------
    --Tag Switching-------------------
    ----------------------------------

    -- Go to next tag by index
    awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),

    -- Go to previous tag by index
    awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),

    -- Go to previously focused tag
    awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),


    ----------------------------------
    --Window Switching----------------
    ----------------------------------

    -- Focus next window by index
    awful.key({ modkey }, "j", function()
      awful.client.focus.byidx(1)
    end, { description = "focus next by index", group = "client" }),

    --Focus previous window by index

    -- awful.key {
    --   modifiers   = { modkey },
    --   key         = 'j',
    --   description = 'focus next by index',
    --   group       = 'client',
    --   on_press    = function()
    --     awful.client.focus.byidx(1)
    --   end,
    -- },

    awful.key({ modkey }, "k", function()
      awful.client.focus.byidx(-1)
    end, { description = "focus previous by index", group = "client" }),

    awful.key({ modkey }, "w", function()
      RC.mainmenu:show()
    end, { description = "show main menu", group = "awesome" }),

    --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function()
      awful.client.swap.byidx(1)
    end, { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function()
      awful.client.swap.byidx(-1)
    end, { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, "Control" }, "j", function()
      awful.screen.focus_relative(1)
    end, { description = "focus the next screen", group = "screen" }),

    awful.key({ modkey, "Control" }, "k", function()
      awful.screen.focus_relative(-1)
    end, { description = "focus the previous screen", group = "screen" }),

    awful.key(
      { modkey },
      "u",
      awful.client.urgent.jumpto,
      { description = "jump to urgent client", group = "client" }
    ),

    awful.key({ modkey }, "Tab", function()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end, { description = "go back", group = "client" }),

    --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- Standard program
    awful.key({ modkey }, "Return", function()
      awful.spawn(terminal)
    end, { description = "open a terminal", group = "launcher" }),


    awful.key({ modkey, "Control" }, "r",
      function()
        awesome.restart()
      end,
      { description = "reload awesome", group = "awesome" }),


    awful.key({ modkey, "Shift" }, "c", function()
      powermenu.visible = true
    end, { description = "quit awesome", group = "awesome" }),



    --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- Layout manipulation
    awful.key({ modkey }, "l", function()
      awful.tag.incmwfact(0.05)
    end, { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey }, "h", function()
      awful.tag.incmwfact(-0.05)
    end, { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function()
      awful.tag.incnmaster(1, nil, true)
    end, { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift" }, "l", function()
      awful.tag.incnmaster(-1, nil, true)
    end, { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function()
      awful.tag.incncol(1, nil, true)
    end, { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function()
      awful.tag.incncol(-1, nil, true)
    end, { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey }, "space", function()
      awful.layout.inc(1)
    end, { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function()
      awful.layout.inc(-1)
    end, { description = "select previous", group = "layout" }),

    awful.key({ modkey, "Control" }, "n", function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:emit_signal("request::activate", "key.unminimize", { raise = true })
      end
    end, { description = "restore minimized", group = "client" }),

    --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    awful.key(
      { modkey }, "d", function()
        awesome.emit_signal("widget::launcher")
      end,
      { description = "show launcher", group = "awesome" }
    ),

    --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- Resize
    awful.key({ modkey, "Control" }, "Down", function()
      awful.client.moveresize(0, 0, 0, -20)
    end),
    awful.key({ modkey, "Control" }, "Up", function()
      awful.client.moveresize(0, 0, 0, 20)
    end),
    awful.key({ modkey, "Control" }, "Left", function()
      awful.client.moveresize(0, 0, -20, 0)
    end),
    awful.key({ modkey, "Control" }, "Right", function()
      awful.client.moveresize(0, 0, 20, 0)
    end),

    -- Move
    awful.key({ modkey, "Shift" }, "Down", function()
      awful.client.moveresize(0, 20, 0, 0)
    end),
    awful.key({ modkey, "Shift" }, "Up", function()
      awful.client.moveresize(0, -20, 0, 0)
    end),
    awful.key({ modkey, "Shift" }, "Left", function()
      awful.client.moveresize(-20, 0, 0, 0)
    end),
    awful.key({ modkey, "Shift" }, "Right", function()
      awful.client.moveresize(20, 0, 0, 0)
    end),

    -- ScreenShot
    awful.key({ "Mod1" }, "Print", function()
      awful.util.spawn("cd Pictures && scrot")
    end, { description = "take a screenshot", group = "screenshots" }),

    -- Brightness Control
    awful.key({}, "XF86MonBrightnessUp", function()
      os.execute("light -A 5")
    end, { description = "+5", group = "hotkeys" }),
    awful.key({}, "XF86MonBrightnessDown", function()
      os.execute("light -U 5")
    end, { description = "-5%", group = "hotkeys" }),

    -- Audio Control
    awful.key({}, "XF86AudioRaiseVolume", function()
      os.execute("amixer set Master 5%+")
    end, { description = "volume up", group = "hotkeys" }),
    awful.key({}, "XF86AudioLowerVolume", function()
      os.execute("amixer set Master 5%-")
    end, { description = "volume down", group = "hotkeys" }),
    awful.key({}, "XF86AudioMute", function()
      os.execute("amixer -q set Master toggle")
    end, { description = "toggle mute", group = "hotkeys" }),

    --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    --Toggle Dock
    awful.key({ "Mod4" }, "z", function() dock.visible = not dock.visible end,
      { description = "Toggle Dock", group = "Custom" }),

    --Toggle control_center
    awful.key({ "Mod4" }, "x", function() control_center.visible = not control_center.visible end,
      { description = "Open Control Center", group = "Custom" }),


    -- Menubar
    awful.key({ modkey }, "p", function()
      menubar.show()
    end, { description = "show the menubar", group = "launcher" })
  )

  return globalkeys
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, {
  __call = function(_, ...)
    return _M.get(...)
  end,
})
