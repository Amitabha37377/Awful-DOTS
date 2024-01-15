local user                                            = require("user")
local color                                           = require("themes.colors")
local helpers                                         = require("helpers")
local theme                                           = {}

theme.useless_gap                                     = 4
theme.font                                            = "Ubuntu Nerd Font 12"
theme.wallpaper                                       = user.wallpaper

local layout_path                                     = "/usr/share/awesome/themes/default/layouts/"
local titlebar_path                                   = user.theme == "biscuit_dark" and
		os.getenv("HOME") .. "/.config/awesome/assets/titlebar_biscuit/" or
		os.getenv("HOME") .. "/.config/awesome/assets/titlebar_icons/"

-------------------------
--Colors-----------------
-------------------------
theme.fg                                              = color.fg_normal
theme.bg                                              = color.bg_dark
theme.bg_normal                                       = color.bg_dark
theme.fg_normal                                       = color.mid_light
theme.bg_focus                                        = color.mid_dark
theme.fg_focus                                        = color.fg_normal
theme.border_width                                    = 1
theme.border_normal                                   = "#000000"
theme.border_focus                                    = "#535d6c"
theme.logout_box_bg                                   = "#00000090"

--------------------------
--Layout icons------------
--------------------------
theme.layout_fairh                                    = layout_path .. "fairhw.png"
theme.layout_fairv                                    = layout_path .. "fairvw.png"
theme.layout_floating                                 = layout_path .. "floatingw.png"
theme.layout_magnifier                                = layout_path .. "magnifierw.png"
theme.layout_max                                      = layout_path .. "maxw.png"
theme.layout_fullscreen                               = layout_path .. "fullscreenw.png"
theme.layout_tilebottom                               = layout_path .. "tilebottomw.png"
theme.layout_tileleft                                 = layout_path .. "tileleftw.png"
theme.layout_tile                                     = layout_path .. "tilew.png"
theme.layout_tiletop                                  = layout_path .. "tiletopw.png"
theme.layout_spiral                                   = layout_path .. "spiralw.png"
theme.layout_dwindle                                  = layout_path .. "dwindlew.png"
theme.layout_cornernw                                 = layout_path .. "cornernw.png"
theme.layout_cornerne                                 = layout_path .. "cornerne.png"
theme.layout_cornersw                                 = layout_path .. "cornersw.png"
theme.layout_cornerse                                 = layout_path .. "cornerse.png"

----------------------------
--Titlebar------------
----------------------------
--Close Button
theme.titlebar_close_button_normal                    = titlebar_path .. "inactive.png"
theme.titlebar_close_button_focus                     = titlebar_path .. "close.png"
theme.titlebar_close_button_normal_hover              = titlebar_path .. "close_hover.png"
theme.titlebar_close_button_focus_hover               = titlebar_path .. "close_hover.png"

--Maximized Button
theme.titlebar_maximized_button_normal_inactive       = titlebar_path .. "inactive.png"
theme.titlebar_maximized_button_focus_inactive        = titlebar_path .. "maximize.png"
theme.titlebar_maximized_button_normal_active         = titlebar_path .. "inactive.png"
theme.titlebar_maximized_button_focus_active          = titlebar_path .. "maximize.png"
theme.titlebar_maximized_button_normal_inactive_hover = titlebar_path .. "maximize-hover.png"
theme.titlebar_maximized_button_focus_inactive_hover  = titlebar_path .. "maximize-hover.png"
theme.titlebar_maximized_button_normal_active_hover   = titlebar_path .. "maximize-hover.png"
theme.titlebar_maximized_button_focus_active_hover    = titlebar_path .. "maximize-hover.png"

--Minimize Button
theme.titlebar_minimize_button_normal                 = titlebar_path .. "inactive.png"
theme.titlebar_minimize_button_focus                  = titlebar_path .. "minimize.png"
theme.titlebar_minimize_button_normal_hover           = titlebar_path .. "minimize_hover.png"
theme.titlebar_minimize_button_focus_hover            = titlebar_path .. "minimize_hover.png"

--Colors
theme.titlebar_bg                                     = color.bg_dark
theme.titlebar_bg_focus                               = color.bg_dark

------------------------
--Taglist---------------
------------------------
theme.taglist_bg_empty                                = color.bg_dark
theme.taglist_fg_empty                                = color.mid_normal
theme.taglist_bg_occupied                             = color.bg_dark
theme.taglist_fg_occupied                             = color.fg_normal
theme.taglist_bg_focus                                = color.bg_light
theme.taglist_fg_focus                                = color.cyan
theme.taglist_fg_urgent                               = color.yellow

theme.taglist_spacing                                 = 15
theme.taglist_font                                    = "Ubuntu nerd font 1 bold"

------------------------
--Tasklist--------------
------------------------
theme.tasklist_bg_minimize                            = color.bg_normal
theme.tasklist_bg_focus                               = color.bg_normal
theme.tasklist_shape_border_width                     = 3
theme.tasklist_shape_border_color                     = color.bg_normal
theme.tasklist_shape_border_color_focus               = color.cyan
theme.tasklist_shape_border_color_minimized           = color.magenta
theme.tasklist_shape_border_color_urgent              = color.yellow

------------------------
--Rightclick Menu-------
------------------------
theme.menu_width                                      = 220
theme.menu_height                                     = 35
theme.menu_font                                       = "Ubuntu nerd font 15"
theme.menu_bg_normal                                  = color.bg_dark
theme.menu_bg_focus                                   = color.lightblue
theme.menu_fg_normal                                  = color.fg_normal
theme.menu_fg_focus                                   = color.bg_dark
theme.menu_border_width                               = 3
theme.menu_border_color                               = color.bg_normal

------------------------
--Notifications---------
------------------------
theme.notification_font                               = "Ubuntu nerd font 13"
theme.notification_border_width                       = 1
theme.notification_border_color                       = color.bg_dim
theme.notification_width                              = 350
theme.notification_shape                              = helpers.rrect(8)

return theme
