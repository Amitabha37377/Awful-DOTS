-- awesome_mode: api-level=4:screen=on

-- load luarocks if installed
pcall(require, 'luarocks.loader')

-- load theme
local beautiful = require 'beautiful'
beautiful.init("~/.config/awesome/themes/theme.lua")

-- load key and mouse bindings
require 'bindings'
require 'rules'
require 'signals'
require 'config.autostart'

--ui
require 'layout.bar'
require 'layout.notifs'
require 'layout.dock'

--widgets
-- require 'popups.launcher.launcher2'
require 'popups.launcher'
require 'popups.menu'
require 'popups.tasklist'
require 'popups.mplayer'
require 'popups.ss_tool'
require 'popups.powermenu'
require 'popups.color_picker'
-- require 'braindamage'
