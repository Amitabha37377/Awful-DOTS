-- module("anybox.titlebar", package.seeall)

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local color = require("deco.colors")
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )


    local top_titlebar = awful.titlebar(c, {
        height    = 20,
        size      = 35,
        position  = "left",
        bg_normal = color.background_dark,
        -- bg_normal = '#00001180',
        bg_focus  = color.background_dark,
        -- bg_focus  = '#00000099',
    })
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )
    top_titlebar:setup {
        {
            {
                -- Left
                awful.titlebar.widget.closebutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.minimizebutton(c),
                spacing = 0,
                layout = wibox.layout.fixed.vertical()
            },
            widget = wibox.container.margin,
            top = 2,
            bottom = 0,
            right = 6,
            left = 3
        },
        {
            -- Middle
            --     {
            --     -- Title
            --         align  = 'center',
            --         widget = awful.titlebar.widget.titlewidget(c)
            --     },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        {
            -- Right
            {
                awful.titlebar.widget.stickybutton(c),
                layout = wibox.layout.fixed.vertical()
            },
            widget = wibox.container.margin,
            top = 0,
            bottom = 0,
            right = 6,
            left = 3,
        },
        layout = wibox.layout.align.vertical
    }
end)
