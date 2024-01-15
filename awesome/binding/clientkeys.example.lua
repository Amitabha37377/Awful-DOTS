function _M.get()
  local clientkeys = gears.table.join(

  --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Original Example Key Bindings

  --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Custom Fix Size
    awful.key({ modkey, "Mod1" }, "Up",
      function(c)
        c.floating = not c.floating
        c.width    = 480
        c.x        = (c.screen.geometry.width - c.width) * 0.5
        c.height   = 400
        c.y        = (c.screen.geometry.height - c.height) * 0.5
      end,
      { description = "480px * 400px", group = "client" }),
    awful.key({ modkey, "Mod1" }, "Down",
      function(c)
        c.floating = not c.floating
        c.width    = 480
        c.x        = (c.screen.geometry.width - c.width) * 0.5
        c.height   = 600
        c.y        = (c.screen.geometry.height - c.height) * 0.5
      end,
      { description = "480px * 600px", group = "client" }),
    awful.key({ modkey, "Mod1" }, "Left",
      function(c)
        c.floating = not c.floating
        c.width    = 600
        c.x        = (c.screen.geometry.width - c.width) * 0.5
        c.height   = c.screen.geometry.height * 0.5
        c.y        = c.screen.geometry.height * 0.25
      end,
      { description = "600px * 50%", group = "client" }),
    awful.key({ modkey, "Mod1" }, "Right",
      function(c)
        c.floating = not c.floating
        c.width    = 800
        c.x        = (c.screen.geometry.width - c.width) * 0.5
        c.height   = c.screen.geometry.height * 0.5
        c.y        = c.screen.geometry.height * 0.25
      end,
      { description = "800px * 50%", group = "client" }),

    --   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- Maximized
    ...
  )

  return clientkeys
end
