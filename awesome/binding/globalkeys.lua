-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local naughty = require("naughty")
local color = require("popups.color")

-- Menubar library
local menubar = require("menubar")

-- Resource Configuration
local modkey = RC.vars.modkey
local terminal = RC.vars.terminal

--Custom Widgets
local dock = require("layout.dock.dock")
local control_center = require("popups.control_center.main")
-- local app_launcher = require("popups.launcher.launcher")
local powermenu = require("popups.powermenu.main")
-- local launcher = require("popups.launcher.spotlight")

local _M = {}


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
  local globalkeys = gears.table.join(

    awful.key {
      modifiers   = { modkey },
      key         = 's',
      description = 'Show Keybindings',
      group       = 'awesome',
      on_press    = hotkeys_popup.show_help
    },

    ----------------------------------
    --Tag Switching-------------------
    ----------------------------------

    -- Go to previous tag by index
    awful.key {
      modifiers   = { modkey },
      key         = "q",
      description = 'view previous',
      group       = 'tag',
      on_press    = awful.tag.viewprev
    },

    -- Go to next tag by index
    awful.key {
      modifiers   = { modkey },
      key         = "w",
      description = 'view next',
      group       = 'tag',
      on_press    = awful.tag.viewnext
    },

    -- Go to previously focused tag
    awful.key {
      modifiers   = { modkey },
      key         = "Escape",
      description = 'go back',
      group       = 'tag',
      on_press    = awful.tag.history.restore
    },


    ----------------------------------
    --Window focus switch-------------
    ----------------------------------

    -- Focus next window by index
    awful.key {
      modifiers   = { modkey },
      key         = 'Right',
      description = 'focus next by index',
      group       = 'client',
      on_press    = function()
        awful.client.focus.byidx(1)
      end,
    },

    -- Focus previous window by index
    awful.key {
      modifiers   = { modkey },
      key         = 'Left',
      description = 'focus previous by index',
      group       = 'client',
      on_press    = function()
        awful.client.focus.byidx(1)
      end,
    },

    -- Focus urgent window
    awful.key {
      modifiers   = { modkey },
      key         = 'u',
      description = 'focus urgent window',
      group       = 'client',
      on_press    = awful.client.urgent.jumpto
    },

    -- Focus previously focused window
    awful.key {
      modifiers   = { modkey },
      key         = 'Tab',
      description = 'go back',
      group       = 'client',
      on_press    = function()
        awful.client.focus.history.previous()
        if client.focus then
          client.focus:raise()
        end
      end
    },

    -----------------------------------------
    -- Open right click menu-----------------
    -----------------------------------------
    awful.key {
      modifiers   = { modkey },
      key         = 'e',
      description = 'show right click menu',
      group       = 'awesome',
      on_press    = function()
        RC.mainmenu:show()
      end,
    },

    -----------------------------------------
    -- Window manipulation-------------------
    -----------------------------------------

    awful.key {
      modifiers   = { modkey, "Shift" },
      key         = 'j',
      description = 'Swap with next client by index',
      group       = 'client move',
      on_press    = function()
        awful.client.swap.byidx(1)
      end,
    },

    awful.key {
      modifiers   = { modkey, "Shift" },
      key         = 'k',
      description = 'Swap with previous client by index',
      group       = 'client move',
      on_press    = function()
        awful.client.swap.byidx(-1)
      end,
    },

    ------------------------------------
    --Screen Switching------------------
    ------------------------------------
    awful.key {
      modifiers   = { modkey, "Control" },
      key         = 'j',
      description = 'Focus next screen',
      group       = 'screen',
      on_press    = function()
        awful.screen.focus_relative(1)
      end,
    },

    awful.key {
      modifiers   = { modkey, "Control" },
      key         = 'k',
      description = 'Focus previous screen',
      group       = 'screen',
      on_press    = function()
        awful.screen.focus_relative(-1)
      end,
    },

    -----------------------------------------
    -- Standard program----------------------
    -----------------------------------------

    --Open terminal
    awful.key {
      modifiers   = { modkey },
      key         = 'Return',
      description = 'Open a terminal',
      group       = 'launcher',
      on_press    = function()
        awful.spawn(terminal)
      end,
    },

    -----------------------------------------
    -- Reload and Quit-----------------------
    -----------------------------------------

    -- Reload awesome
    awful.key {
      modifiers   = { modkey, "Control" },
      key         = 'r',
      description = 'reload awesome',
      group       = 'awesome',
      on_press    = function()
        awesome.restart()
      end,
    },

    --Toggle powermenu
    awful.key {
      modifiers   = { modkey, "Shift" },
      key         = 'c',
      description = 'Powermenu',
      group       = 'awesome',
      on_press    = function()
        powermenu.visible = not powermenu.visible
      end,
    },





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
