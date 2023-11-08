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
require 'ui.bar'
require 'ui.launcher'
require 'ui.menu'
require 'ui.control_center'
