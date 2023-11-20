local awful       = require 'awful'
local apps        = require 'config.apps'

local awesomemenu = awful.menu {
	items = {
		-- { 'awesome',       _M.awesomemenu, beautiful.awesome_icon },
		{ 'open terminal',    apps.terminal },
		{ 'change wallpaper', 'nitrogen' },
		{ 'change theme',     'lxappearance' }
	}
}

return awesomemenu
