local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local ruled = require("ruled")
local colors = require("deco.colors")
local beautiful = require("beautiful")
local clicable_container = require("deco.clickable-container")

-- Defaults
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = 48
naughty.config.defaults.timeout = 5
naughty.config.defaults.title = 'System Notification'
naughty.config.defaults.margin = 24
naughty.config.defaults.border_width = 0
naughty.config.defaults.position = 'top_right'
naughty.config.defaults.shape = function(cr, w, h)
  gears.shape.rounded_rect(cr, w, h, 9)
end

-- Apply theme variables
naughty.config.padding = 5
naughty.config.spacing = 5
naughty.config.icon_dirs = {
  '/usr/share/icons/Tela',
  '/usr/share/icons/Tela-blue-dark',
  '/usr/share/icons/Papirus/',
  '/usr/share/icons/la-capitaine-icon-theme/',
  '/usr/share/icons/gnome/',
  '/usr/share/icons/hicolor/',
  '/usr/share/pixmaps/'
}
naughty.config.icon_formats = { 'svg', 'png', 'jpg', 'gif' }


-- Presets / rules

ruled.notification.connect_signal(
  'request::rules',
  function()
    -- Critical notifs
    ruled.notification.append_rule {
      rule       = { urgency = 'critical' },
      properties = {
        font             = 'Ubuntu Nerd Font 14',
        bg               = '#ff0000',
        fg               = '#ffffff',
        margin           = 16,
        position         = 'top_right',
        implicit_timeout = 0
      }
    }

    -- Normal notifs
    ruled.notification.append_rule {
      rule       = { urgency = 'normal' },
      properties = {
        font             = 'Ubuntu Nerd Font 14',
        bg               = "#1a1b26",
        fg               = "#a9b1d6",
        margin           = 16,
        position         = 'top_right',
        implicit_timeout = 5
      }
    }

    -- Low notifs
    ruled.notification.append_rule {
      rule       = { urgency = 'low' },
      properties = {
        font             = 'Ubuntu Nerd Font 14',
        bg               = beautiful.transparent,
        fg               = beautiful.fg_normal,
        margin           = 16,
        position         = 'top_right',
        implicit_timeout = 5
      }
    }
  end
)

-- Error handling
naughty.connect_signal(
  'request::display_error',
  function(message, startup)
    naughty.notification {
      urgency  = 'critical',
      title    = 'Oops, an error happened' .. (startup and ' during startup!' or '!'),
      message  = message,
      app_name = 'System Notification',
      icon     = beautiful.awesome_icon
    }
  end
)

-- -- XDG icon lookup
-- naughty.connect_signal(
-- 	'request::icon',
-- 	function(n, context, hints)
-- 		if context ~= 'app_icon' then return end
--
-- 		local path = menubar.utils.lookup_icon(hints.app_icon) or
-- 		menubar.utils.lookup_icon(hints.app_icon:lower())
--
-- 		if path then
-- 			n.icon = path
-- 		end
-- 	end
-- )

-- Connect to naughty on display signal
naughty.connect_signal(
  'request::display',
  function(n)
    -- Actions Blueprint
    local actions_template = wibox.widget {
      notification = n,
      base_layout = wibox.widget {
        spacing = 0,
        layout  = wibox.layout.flex.horizontal
      },
      widget_template = {
        {
          {
            {
              {
                id     = 'text_role',
                font   = 'Ubuntu Nerd Font bold 14',
                widget = wibox.widget.textbox
              },
              widget = clicable_container,
            },
            widget = wibox.container.place
          },
          bg            = beautiful.groups_bg,
          shape         = gears.shape.rounded_rect,
          forced_height = 45,
          widget        = wibox.container.background
        },
        margins = 6,
        widget  = wibox.container.margin
      },
      style = { underline_normal = false, underline_selected = true },
      widget = naughty.list.actions
    }

    -- Notifbox Blueprint
    naughty.layout.box {
      notification = n,
      type = 'notification',
      screen = awful.screen.preferred(),
      shape = gears.shape.rectangle,
      widget_template = {
        {
          {
            {
              {
                {
                  {
                    {
                      {
                        {
                          {
                            markup = n.app_name or 'System Notification',
                            font = 'Inter Bold 14',
                            align = 'center',
                            valign = 'center',
                            widget = wibox.widget.textbox

                          },
                          margins = beautiful.notification_margin,
                          widget  = wibox.container.margin,
                        },
                        bg     = beautiful.background,
                        widget = wibox.container.background,
                      },
                      {
                        {
                          {
                            resize_strategy = 'center',
                            widget = naughty.widget.icon,
                          },
                          margins = beautiful.notification_margin,
                          widget  = wibox.container.margin,
                        },
                        {
                          {
                            layout = wibox.layout.align.vertical,
                            expand = 'none',
                            nil,
                            {
                              {
                                align = 'left',
                                widget = naughty.widget.title
                              },
                              {
                                align = 'left',
                                widget = naughty.widget.message,
                              },
                              layout = wibox.layout.fixed.vertical
                            },
                            nil
                          },
                          margins = beautiful.notification_margin,
                          widget  = wibox.container.margin,
                        },
                        layout = wibox.layout.fixed.horizontal,
                      },
                      fill_space = true,
                      spacing    = beautiful.notification_margin,
                      layout     = wibox.layout.fixed.vertical,
                    },
                    -- Margin between the fake background
                    -- Set to 0 to preserve the 'titlebar' effect
                    margins = 0,
                    widget  = wibox.container.margin,
                  },
                  bg     = beautiful.transparent,
                  widget = wibox.container.background,
                },
                -- Actions
                actions_template,
                spacing = 6,
                layout  = wibox.layout.fixed.vertical,
              },
              bg     = beautiful.transparent,
              id     = 'background_role',
              widget = naughty.container.background,
            },
            strategy = 'min',
            width    = 240,
            widget   = wibox.container.constraint,
          },
          strategy = 'max',
          width    = beautiful.notification_max_width or 750,
          widget   = wibox.container.constraint
        },
        bg = beautiful.background,
        shape = gears.shape.rounded_rect,
        widget = wibox.container.background
      }
    }

    -- -- Destroy popups if dont_disturb mode is on
    -- -- Or if the right_panel is visible
    -- local focused = awful.screen.focused()
    -- if _G.dont_disturb or
    -- 	(focused.right_panel and focused.right_panel.visible) then
    -- 	naughty.destroy_all_notifications(nil, 1)
    -- end
    --
  end
)
-- Presets / rules

-- ruled.notification.connect_signal(
--   'request::rules',
--   function()
--     -- Critical notifs
--     ruled.notification.append_rule {
--       rule       = { urgency = 'critical' },
--       properties = {
--         font             = 'Inter Bold 10',
--         bg               = '#ff0000',
--         fg               = '#ffffff',
--         margin           = 24,
--         position         = 'top_right',
--         implicit_timeout = 0
--       }
--     }
--
--     -- Normal notifs
--     ruled.notification.append_rule {
--       rule       = { urgency = 'normal' },
--       properties = {
--         font             = 'Inter Regular 10',
--         bg               = beautiful.transparent,
--         fg               = beautiful.fg_normal,
--         margin           = 24,
--         position         = 'top_right',
--         implicit_timeout = 5
--       }
--     }
--
--     -- Low notifs
--     ruled.notification.append_rule {
--       rule       = { urgency = 'low' },
--       properties = {
--         font             = 'Inter Regular 10',
--         bg               = beautiful.transparent,
--         fg               = beautiful.fg_normal,
--         margin           = 24,
--         position         = 'top_right',
--         implicit_timeout = 5
--       }
--     }
--   end
-- )
