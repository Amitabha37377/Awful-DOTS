local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local bling = require("bling")

--Colors
local color = require("layout.dock.color")
-- local icon_path = require("layout.dock.icon_path")


-- App Launcher Arguments
local args = {
  apps_per_column = 5,
  terminal = "kitty",
  favorites = { "firefox", "thunar", "kitty", "vokoscreenNG", "wezterm", "vlc", "lxappearance" },
  sort_alphabetically = true,
  reverse_sort_alphabetically = false,
  background = color.background_dark,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
  app_shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
  app_normal_color = color.background_lighter,         -- App normal color
  app_normal_hover_color = color.background_morelight, -- App normal hover color
  app_selected_color = color.white,                    -- App selected color
  app_selected_hover_color = color.blueish_white,      -- App selected hover color
  app_name_font = "Ubuntu Nerd Font 12",
  app_name_normal_color = color.white,
  prompt_icon = "",
  prompt_icon_font = "Ubuntu Nerd Font Bold 14",
  prompt_icon_color = color.blue,
  prompt_font = "Ubuntu Nerd Font 18",
  prompt_text_color = color.white,
  prompt_color = "#343b58",
  prompt_cursor_color = color.blueish_white,
  prompt_padding = dpi(15),
  border_width = dpi(2),
  border_color = color.blue,
  wrap_page_scrolling = true,
  wrap_app_scrolling = true,
  search_commands = true
}

--App Launcher
local app_launcher = bling.widget.app_launcher(args)

return app_launcher
