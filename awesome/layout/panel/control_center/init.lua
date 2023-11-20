local wibox = require('wibox')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi
local helpers = require('helpers')
local color = require("themes.colors")

local header = require('layout.panel.control_center.header')
local buttons = require('layout.panel.control_center.buttons')
local vol_slider = require('layout.panel.control_center.vol_slider')
local bright_slider = require('layout.panel.control_center.bright_slider')
local notif_center = require('layout.panel.control_center.notif_center')

local cc = {
	header,
	buttons,
	bright_slider,
	vol_slider,
	notif_center,
	layout = wibox.layout.fixed.vertical
}

return cc
