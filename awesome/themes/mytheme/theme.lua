local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi


local color                                           = require("layout.topbar.colors")

local theme                                           = {}

theme.font                                            = "CaskaydiaCove Nerd Font 12"
theme.fg                                              = color.white
theme.bg                                              = "#24283b"
theme.bg_normal                                       = "#24283b"
theme.fg_normal                                       = color.white
theme.bg_focus                                        = "#535d6c"
theme.fg_focus                                        = color.white
theme.border_width                                    = 1
theme.border_normal                                   = "#000000"
theme.border_focus                                    = "#535d6c"

theme.logout_box_bg                                   = "#00000090"

--Colorscheme
theme.background_dark                                 = "#1a1b26"
theme.background_lighter                              = "#24283b"
theme.white                                           = "#a9b1d6"
theme.blueish_white                                   = "#89b4fa"
theme.red                                             = "#F7768E"
theme.green                                           = "#73daca"
theme.yellow                                          = "#E0AF68"
theme.blue                                            = "#7AA2F7"
theme.magenta                                         = "#BB9AF7"
theme.cyan                                            = "#7dcfff"

--Default wallpaper
theme.wallpaper                                       = os.getenv("HOME") .. "/.config/awesome/Wallpapers/catMachup.jpg"

--Close Button
theme.titlebar_close_button_normal                    = "~/.config/awesome/themes/mytheme/titlebar_icons/inactive.png"
theme.titlebar_close_button_focus                     = "~/.config/awesome/themes/mytheme/titlebar_icons/close.png"
theme.titlebar_close_button_normal_hover              = "~/.config/awesome/themes/mytheme/titlebar_icons/close_hover.png"
theme.titlebar_close_button_focus_hover               = "~/.config/awesome/themes/mytheme/titlebar_icons/close_hover.png"

--Maximized Button
theme.titlebar_maximized_button_normal_inactive       = "~/.config/awesome/themes/mytheme/titlebar_icons/inactive.png"
theme.titlebar_maximized_button_focus_inactive        = "~/.config/awesome/themes/mytheme/titlebar_icons/maximize.png"
theme.titlebar_maximized_button_normal_active         = "~/.config/awesome/themes/mytheme/titlebar_icons/inactive.png"
theme.titlebar_maximized_button_focus_active          = "~/.config/awesome/themes/mytheme/titlebar_icons/maximize.png"
theme.titlebar_maximized_button_normal_inactive_hover =
"~/.config/awesome/themes/mytheme/titlebar_icons/maximize-hover.png"
theme.titlebar_maximized_button_focus_inactive_hover  =
"~/.config/awesome/themes/mytheme/titlebar_icons/maximize-hover.png"
theme.titlebar_maximized_button_normal_active_hover   =
"~/.config/awesome/themes/mytheme/titlebar_icons/maximize-hover.png"
theme.titlebar_maximized_button_focus_active_hover    = "~/.config/awesome/themes/mytheme/titlebar_icons/maximize-hover.png"

theme.bg_systray                                      = color.background_dark

--Minimize Button
theme.titlebar_minimize_button_normal                 = "~/.config/awesome/themes/mytheme/titlebar_icons/inactive.png"
theme.titlebar_minimize_button_focus                  = "~/.config/awesome/themes/mytheme/titlebar_icons/minimize.png"
theme.titlebar_minimize_button_normal_hover           = "~/.config/awesome/themes/mytheme/titlebar_icons/minimize_hover.png"

theme.titlebar_minimize_button_focus_hover            = "~/.config/awesome/themes/mytheme/titlebar_icons/minimize_hover.png"



--Sticky Button
theme.titlebar_sticky_button_normal_inactive = "~/.config/awesome/themes/mytheme/titlebar_icons/inactive.png"
theme.titlebar_sticky_button_focus_inactive  = "~/.config/awesome/themes/mytheme/titlebar_icons/pin.png"
theme.titlebar_sticky_button_normal_active   = "~/.config/awesome/themes/mytheme/titlebar_icons/inactive.png"
theme.titlebar_sticky_button_focus_active    = "~/.config/awesome/themes/mytheme/titlebar_icons/pin2.png"

--Disable icons in tasklist
theme.tasklist_disable_task_name             = true

--Tasklist Themesmin
theme.tasklist_bg_minimize                   = "#535d6c"
theme.tasklist_bg_focus                      = "#222222"

theme.tasklist_shape_border_width            = 3
theme.tasklist_shape_border_color            = "#000000"

-- Default layout icons
theme.layout_fairh                           = "/usr/share/awesome/themes/default/layouts/fairhw.png"
theme.layout_fairv                           = "/usr/share/awesome/themes/default/layouts/fairvw.png"
theme.layout_floating                        = "/usr/share/awesome/themes/default/layouts/floatingw.png"
theme.layout_magnifier                       = "/usr/share/awesome/themes/default/layouts/magnifierw.png"
theme.layout_max                             = "/usr/share/awesome/themes/default/layouts/maxw.png"
theme.layout_fullscreen                      = "/usr/share/awesome/themes/default/layouts/fullscreenw.png"
theme.layout_tilebottom                      = "/usr/share/awesome/themes/default/layouts/tilebottomw.png"
theme.layout_tileleft                        = "/usr/share/awesome/themes/default/layouts/tileleftw.png"
theme.layout_tile                            = "/usr/share/awesome/themes/default/layouts/tilew.png"
theme.layout_tiletop                         = "/usr/share/awesome/themes/default/layouts/tiletopw.png"
theme.layout_spiral                          = "/usr/share/awesome/themes/default/layouts/spiralw.png"
theme.layout_dwindle                         = "/usr/share/awesome/themes/default/layouts/dwindlew.png"
theme.layout_cornernw                        = "/usr/share/awesome/themes/default/layouts/cornernw.png"
theme.layout_cornerne                        = "/usr/share/awesome/themes/default/layouts/cornerne.png"
theme.layout_cornersw                        = "/usr/share/awesome/themes/default/layouts/cornersw.png"
theme.layout_cornerse                        = "/usr/share/awesome/themes/default/layouts/cornerse.png"

--Taglist_improved themes
-- --Gruvbox Theme taglist
-- theme.taglist_bg_empty                          = "#00000080"
-- theme.taglist_fg_empty                          = "#928374"
-- theme.taglist_bg_occupied                       = "#504945"
-- theme.taglist_fg_occupied                       = "#EBDBB2"
-- theme.taglist_bg_focus                          = "#83A598"
-- theme.taglist_fg_focus                          = "#282828"

-- --Rosepine
-- theme.taglist_bg_empty    = "#2a2a2a"
-- theme.taglist_fg_empty    = "#b3b3b3"
-- theme.taglist_bg_occupied = "#404040"
-- theme.taglist_fg_occupied = "#ffffff"
-- theme.taglist_bg_focus    = "#a94c4c"
-- theme.taglist_fg_focus    = "#ffffff"

-- --Ayu Dark
-- theme.taglist_bg_empty    = "#2b2b2b"
-- theme.taglist_fg_empty    = "#bababa"
-- theme.taglist_bg_occupied = "#3e3e3e"
-- theme.taglist_fg_occupied = "#f0f0f0"
-- theme.taglist_bg_focus    = "#6ab0c1"
-- theme.taglist_fg_focus    = "#2b2b2b"

-- Catppuccino
theme.taglist_bg_empty                       = color.background_lighter
theme.taglist_fg_empty                       = color.white
-- theme.taglist_bg_occupied                       = "#434c5e"
theme.taglist_bg_occupied                    = color.background_lighter
theme.taglist_fg_occupied                    = color.white
theme.taglist_bg_focus                       = color.background_lighter
theme.taglist_fg_focus                       = color.cyan

-- Other Taglist settings

theme.taglist_spacing                        = 2
theme.taglist_shape_border_width             = 0
theme.taglist_shape_border_radius            = 20
theme.taglist_shape_border_color             = "#00000040"

-- --Notifications
theme.notification_font                      = "Ubuntu Nerd Font 14"
-- theme.notification_bg                        = "#1a1b26"
theme.notification_fg                        = "#a9b1d6"
-- theme.notification_border_width              = 8
-- theme.notification_width                     = 500
-- theme.notification_max_width                 = 500
-- theme.notification_margin                    = 5
--
-- theme.notification_max_height                = 100
-- theme.notification_height                    = 80

theme.notification_position                  = 'top_right'
theme.notification_margin                    = dpi(10)
theme.notification_border_width              = dpi(0)
theme.notification_spacing                   = dpi(15)
theme.notification_icon_resize_strategy      = 'center'
theme.notification_icon_size                 = dpi(300)


--Theme
theme.font               = "Ubuntu Nerd Font 14"
theme.icon_empty_notibox = "~/.config/awesome/themes/mytheme/icons/mail-receive.svg"

return theme
