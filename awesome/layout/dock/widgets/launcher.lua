--Standard Modules
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local bling = require("bling")

--Colors
local color = require("layout.dock.color")

local user = require("popups.user_profile")
local icon_path = user.icon_theme_path

--Main Widget
local button1 = wibox.widget {
	{
		{
			widget = wibox.widget.imagebox,
			image = os.getenv("HOME") .. icon_path .. "launch.svg",
			resize = true,
			opacity = 1,
		},
		left   = dpi(1),
		right  = dpi(1),
		top    = dpi(2),
		bottom = dpi(2),
		widget = wibox.container.margin
	},
	bg = color.background_dark,
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
	forced_height = dpi(48),
	forced_width = dpi(48),
}

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

--Toggle App Launcher
button1:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		app_launcher:toggle()
		-- awesome.emit_signal("widget::launcher")
	end
end)

--Hover highlight effects
button1:connect_signal("mouse::enter", function()
	button1.bg = color.background_lighter
end)

button1:connect_signal("mouse::leave", function()
	button1.bg = color.background_dark
end)

button1:connect_signal("button::press", function()
	button1.bg = color.background_morelight
end)

button1:connect_signal("button::release", function()
	button1.bg = color.background_lighter
end)


return button1


--Arguments for app launcher
-- local args = {
--     terminal = "alacritty"                                            -- Set default terminal
--     favorites = { "firefox", "wezterm" }                              -- Favorites are given priority and are bubbled to top of the list
--     search_commands = true                                            -- Search by app name AND commandline command
--     skip_names = { "Discord" }                                        -- List of apps to omit from launcher
--     skip_commands = { "thunar" }                                      -- List of commandline commands to omit from launcher
--     skip_empty_icons = true                                           -- Skip applications without icons
--     sort_alphabetically = true                                        -- Sorts applications alphabetically
--     reverse_sort_alphabetically = false                               -- Sort in reverse alphabetical order (NOTE: must set `sort_alphabetically = false` to take effect)
--     select_before_spawn = true                                        -- When selecting by mouse, click once to select app, click once more to open the app.
--     hide_on_left_clicked_outside = true                               -- Hide launcher on left click outside the launcher popup
--     hide_on_right_clicked_outside = true                              -- Hide launcher on right click outside the launcher popup
--     hide_on_launch = true                                             -- Hide launcher when spawning application
--     try_to_keep_index_after_searching = false                         -- After a search, reselect the previously selected app
--     reset_on_hide = true                                              -- When you hide the launcher, reset search query
--     save_history = true                                               -- Save search history
--     wrap_page_scrolling = true                                        -- Allow scrolling to wrap back to beginning/end of launcher list
--     wrap_app_scrolling = true                                         -- Set app scrolling
--
--     default_app_icon_name = "standard.svg"                            -- Sets default app icon name for apps without icon names
--     default_app_icon_path = "~/icons/"                                -- Sets default app icon path for apps without icon paths
--     icon_theme = "application"                                        -- Set icon theme
--     icon_size = 24                                                    -- Set icon size
--
--     type = "dock"                                                     -- awful.popup type ("dock", "desktop", "normal"...).  See awesomewm docs for more detail
--     show_on_focused_screen = true                                     -- Should app launcher show on currently focused screen
--     screen = awful.screen                                             -- Screen you want the launcher to launch to
--     placement = awful.placement.top_left                              -- Where launcher should be placed ("awful.placement.centered").
--     rubato = { x = rubato_animation_x, y = rubato_animation_y }       -- Rubato animation to apply to launcher
--     shrink_width = true                                               -- Automatically shrink width of launcher to fit varying numbers of apps in list (works on apps_per_column)
--     shrink_height = true                                              -- Automatically shrink height of launcher to fit varying numbers of apps in list (works on apps_per_row)
--     background = "#FFFFFF"                                            -- Set bg color
--     border_width = dpi(0)                                             -- Set border width of popup
--     border_color = "#FFFFFF"                                          -- Set border color of popup
--     shape = function(cr, width, height)
--       gears.shape.rectangle(cr, width, height)
--     end                                                               -- Set shape for launcher
--     prompt_height = dpi(50)                                           -- Prompt height
--     prompt_margins = dpi(30)                                          -- Prompt margins
--     prompt_paddings = dpi(15)                                         -- Prompt padding
--     shape = function(cr, width, height)
--       gears.shape.rectangle(cr, width, height)
--     end                                                               -- Set shape for prompt
--     prompt_color = "#000000"                                          -- Prompt background color
--     prompt_border_width = dpi(0)                                      -- Prompt border width
--     prompt_border_color = "#000000"                                   -- Prompt border color
--     prompt_text_halign = "center"                                     -- Prompt text horizontal alignment
--     prompt_text_valign = "center"                                     -- Prompt text vertical alignment
--     prompt_icon_text_spacing = dpi(10)                                -- Prompt icon text spacing
--     prompt_show_icon = true                                           -- Should prompt show icon (?)
--     prompt_icon_font = "Comic Sans"                                   -- Prompt icon font
--     prompt_icon_color = "#000000"                                     -- Prompt icon color
--     prompt_icon = ""                                                 -- Prompt icon
--     prompt_icon_markup = string.format(
--         "<span size='xx-large' foreground='%s'>%s</span>",
--         args.prompt_icon_color, args.prompt_icon
--     )                                                                 -- Prompt icon markup
--     prompt_text = "<b>Search</b>:"                                    -- Prompt text
--     prompt_start_text = "manager"                                     -- Set string for prompt to start with
--     prompt_font = "Comic Sans"                                        -- Prompt font
--     prompt_text_color = "#FFFFFF"                                     -- Prompt text color
--     prompt_cursor_color = "#000000"                                   -- Prompt cursor color
--
--     apps_per_row = 3                                                  -- Set how many apps should appear in each row
--     apps_per_column = 3                                               -- Set how many apps should appear in each column
--     apps_margin = {left = dpi(40), right = dpi(40), bottom = dpi(30)} -- Margin between apps
--     apps_spacing = dpi(10)                                            -- Spacing between apps
--
--     expand_apps = true                                                -- Should apps expand to fill width of launcher
--     app_width = dpi(400)                                              -- Width of each app
--     app_height = dpi(40)                                              -- Height of each app
--     app_shape = function(cr, width, height)
--       gears.shape.rectangle(cr, width, height)
--     end                                                               -- Shape of each app
--     app_normal_color = "#000000"                                      -- App normal color
--     app_normal_hover_color = "#111111"                                -- App normal hover color
--     app_selected_color = "#FFFFFF"                                    -- App selected color
--     app_selected_hover_color = "#EEEEEE"                              -- App selected hover color
--     app_content_padding = dpi(10)                                     -- App content padding
--     app_content_spacing = dpi(10)                                     -- App content spacing
--     app_show_icon = true                                              -- Should show icon?
--     app_icon_halign = "center"                                        -- App icon horizontal alignment
--     app_icon_width = dpi(70)                                          -- App icon wigth
--     app_icon_height = dpi(70)                                         -- App icon height
--     app_show_name = true                                              -- Should show app name?
--     app_name_generic_name_spacing = dpi(0)                            -- Generic name spacing (If show_generic_name)
--     app_name_halign = "center"                                        -- App name horizontal alignment
--     app_name_font = "Comic Sans"                                      -- App name font
--     app_name_normal_color = "#FFFFFF"                                 -- App name normal color
--     app_name_selected_color = "#000000"                               -- App name selected color
--     app_show_generic_name = true                                      -- Should show generic app name?
-- }
