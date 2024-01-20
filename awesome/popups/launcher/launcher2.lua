local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local bling = require("modules.bling")

--Colors
local color = require("themes.colors")
-- local icon_path = require("layout.dock.icon_path")


-- App Launcher Arguments
local args = {
	apps_per_column = 6,
	apps_per_row = 5,
	terminal = "kitty",
	favorites = { "firefox", "thunar", "kitty", "vokoscreenNG", "wezterm", "vlc", "lxappearance" },
	sort_alphabetically = true,
	reverse_sort_alphabetically = false,
	background = color.bg_dim,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 10)
	end,
	app_shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 10)
	end,
	app_normal_color = color.bg_dim,           -- App normal color
	app_normal_hover_color = color.bg_normal,  -- App normal hover color
	app_selected_color = color.mid_light,      -- App selected color
	app_selected_hover_color = color.fg_normal, -- App selected hover color
	app_name_font = "Ubuntu Nerd Font bold 12",
	app_name_normal_color = color.fg_normal,
	app_width = dpi(220),
	prompt_margin = dpi(80),
	prompt_icon = "",
	prompt_icon_font = "Ubuntu Nerd Font Bold 14",
	prompt_icon_color = color.blue,
	prompt_font = "Ubuntu Nerd Font 18",
	prompt_text_color = color.fg_normal,
	prompt_color = color.bg_light,
	prompt_cursor_color = color.lightblue,
	-- prompt_padding = dpi(5),
	border_width = dpi(3),
	border_color = color.bg_light,
	wrap_page_scrolling = true,
	wrap_app_scrolling = true,
	search_commands = true
}

--App Launcher
local app_launcher = bling.widget.app_launcher(args)

awesome.connect_signal("launcher2::toggle", function()
	app_launcher:toggle()
end)
