-- awesome_mode: api-level=4:screen=on

-- load luarocks if installed
pcall(require, "luarocks.loader")

-- load theme
local beautiful = require("beautiful")
beautiful.init("~/.config/awesome/themes/theme.lua")

-- load key and mouse bindings
require("bindings")
require("rules")
require("signals")
require("config.autostart")

--ui layout
require("layout.topbar")
require("layout.naughty")
require("layout.dock")

--popup widgets
require("popups.tasklist")
require("popups.control_center")
require("popups.ss_tool")
require("popups.mplayer")
require("popups.launcher")
require("popups.launcher.launcher2")
require("popups.color_picker")
