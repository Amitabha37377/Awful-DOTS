local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Custom Modules
local color = require("popups.color")
local user = require("popups.user_profile")

local icon_path = os.getenv("HOME") .. '/.config/awesome/popups/dashboard/home/widgets/web_icons/'



local create_button = function(icon, command)
  local image = wibox.widget {
    image = icon,
    widget = wibox.widget.imagebox,
    resize = true,
    forced_height = dpi(60),
    forced_width = dpi(60)
  }

  local button = wibox.widget {
    {
      {
        image,
        widget = wibox.container.place
      },
      widget = wibox.container.margin,
      margins = dpi(6)
    },
    widget = wibox.container.background,
    bg = color.background_lighter,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 10)
    end,
  }

  button:connect_signal("mouse::enter", function()
    button.bg = color.background_lighter2
  end)

  button:connect_signal("mouse::leave", function()
    button.bg = color.background_lighter
  end)

  button:connect_signal("button::press", function()
    button.bg = color.background_morelight
  end)

  button:connect_signal("button::release", function()
    button.bg = color.background_lighter2
    awful.spawn(user.browser .. command)
  end)


  return button
end


local reddit = create_button(icon_path .. 'reddit.png', 'https://www.reddit.com/')
local github = create_button(icon_path .. 'git.png', 'https://github.com/')
local chess_com = create_button(icon_path .. 'chess.png', 'https://www.chess.com/')
local youtube = create_button(icon_path .. 'yt.png', 'https://www.youtube.com/')

---------------------------
--Main widget--------------
---------------------------

local web_launch = wibox.widget {
  {
    {
      {
        {
          {
            reddit,
            widget = wibox.container.margin,
            top    = dpi(12),
            bottom = dpi(12),
            left   = dpi(12),
            right  = dpi(6)
          },
          {
            github,
            widget = wibox.container.margin,
            top    = dpi(12),
            bottom = dpi(12),
            left   = dpi(6),
            right  = dpi(12)
          },
          layout = wibox.layout.fixed.horizontal
        },
        {
          {
            chess_com,
            widget = wibox.container.margin,
            top    = dpi(12),
            bottom = dpi(12),
            left   = dpi(12),
            right  = dpi(6)
          },
          {
            youtube,
            widget = wibox.container.margin,
            top    = dpi(12),
            bottom = dpi(12),
            left   = dpi(6),
            right  = dpi(12)
          },
          layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.fixed.vertical
      },
      widget = wibox.container.place
    },
    widget = wibox.container.background,
    bg = color.background_lighter,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 10)
    end,

  },
  widget = wibox.container.margin,
  margins = dpi(12),
  forced_width = dpi(220),
  forced_height = dpi(215),
}

-------------------------
--Sys_info---------------
-------------------------

---Ram-----------------
local text1 = '<span color="' ..
    color.blueish_white .. '" font="Ubuntu Nerd Font 16">' .. '  :   ' .. '1.58 GiB' .. '</span>'
local icon1 = '<span color="' .. color.red .. '" font="Ubuntu Nerd Font bold 17">' .. '' .. '</span>'

local ram_usage = wibox.widget {
  markup = icon1 .. text1,
  font = "Ubuntu Nerd Font Bold 14",
  widget = wibox.widget.textbox,
  fg = color.white,
}

local ram_text = wibox.widget {
  ram_usage,
  widget = wibox.container.margin,
  top = dpi(6),
  bottom = dpi(6),
  right = dpi(6),
  left = dpi(25),
  -- forced_height = dpi(40)
}

-- Fetch ram_usage info
awful.spawn.easy_async_with_shell([[ free -m | awk 'NR==2 {print $3}'
]], function(out)
  local str = string.gsub(out, "%s+", "")
  local val = tonumber(str) / 1000
  ram_usage.markup = icon1 .. '<span color="' ..
      color.blueish_white .. '" font="Ubuntu Nerd Font 16">' .. '  :   ' .. val .. ' GiB' .. '</span>'
end)

--Update ram_usage every time
local update_ram = function()
  awful.spawn.easy_async_with_shell([[ free -m | awk 'NR==2 {print $3}'
]], function(out)
    local str = string.gsub(out, "%s+", "")
    local val = tonumber(str) / 1000
    ram_usage.markup = icon1 .. '<span color="' ..
        color.blueish_white .. '" font="Ubuntu Nerd Font 16">' .. '  :   ' .. val .. ' GiB' .. '</span>'
  end)
end

local update_ram_timer = gears.timer({
  timeout = 30,
  call_now = true,
  autostart = true,
  callback = update_ram
})


---Cpu----------------------
local text2 = '<span color="' ..
    color.blueish_white .. '" font="Ubuntu Nerd Font 16">' .. '  :   ' .. '1%' .. '</span>'
local icon2 = '<span color="' .. color.red .. '" font="Ubuntu Nerd Font bold 17">' .. '' .. '</span>'

local cpu_usage = wibox.widget {
  -- text = user.name,
  markup = icon2 .. text2,
  font = "Ubuntu Nerd Font Bold 14",
  widget = wibox.widget.textbox,
  fg = color.white,
  -- forced_width = dpi(300),
}

local cpu_text = wibox.widget {
  cpu_usage,
  widget = wibox.container.margin,
  top = dpi(6),
  bottom = dpi(6),
  right = dpi(9),
  left = dpi(25),
  -- forced_height = dpi(40)
}

-- Fetch cpu_usage info
awful.spawn.easy_async_with_shell([[ echo ""$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"%"
]], function(out)
  local str = string.gsub(out, "%s+", "")

  cpu_usage.markup = icon2 .. '<span color="' ..
      color.blueish_white .. '" font="Ubuntu Nerd Font 16">' .. '  :   ' .. str .. '</span>'
end)

--Update cpu_usage every time
local update_cpu = function()
  awful.spawn.easy_async_with_shell([[ echo ""$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"%"
]], function(out)
    local str = string.gsub(out, "%s+", "")

    cpu_usage.markup = icon2 .. '<span color="' ..
        color.blueish_white .. '" font="Ubuntu Nerd Font 16">' .. '  :   ' .. str .. '</span>'
  end)
end

local update_cpu_timer = gears.timer({
  timeout = 10,
  call_now = true,
  autostart = true,
  callback = update_cpu
})


---Storage----------------------
local text3 = '<span color="' ..
    color.blueish_white .. '" font="Ubuntu Nerd Font 16">' .. '  :   ' .. '69/334 GiB' .. '</span>'
local icon3 = '<span color="' .. color.red .. '" font="Ubuntu Nerd Font bold 17">' .. '󰨣' .. '</span>'

local storage_usage = wibox.widget {
  markup = icon3 .. text3,
  font = "Ubuntu Nerd Font Bold 14",
  widget = wibox.widget.textbox,
  fg = color.white,
}

local storage_text = wibox.widget {
  storage_usage,
  widget = wibox.container.margin,
  top = dpi(6),
  bottom = dpi(6),
  right = dpi(9),
  left = dpi(25),
}

-- Fetch storage_usage info
awful.spawn.easy_async_with_shell([[ df -h --total | tail -n 1 | awk '{print $3 "/" $4}'
]], function(out)
  local str = string.gsub(out, "%s+", "")

  storage_usage.markup = icon3 .. '<span color="' ..
      color.blueish_white .. '" font="Ubuntu Nerd Font 16">' .. '  :   ' .. str .. '</span>'
end)

--Update storage_usage every time
local update_storage = function()
  awful.spawn.easy_async_with_shell([[df -h --total | tail -n 1 | awk '{print $3 "/" $4}'
]], function(out)
    local str = string.gsub(out, "%s+", "")

    storage_usage.markup = icon3 .. '<span color="' ..
        color.blueish_white .. '" font="Ubuntu Nerd Font 16">' .. '  :   ' .. str .. '</span>'
  end)
end

local update_storage_timer = gears.timer({
  timeout = 7200,
  call_now = true,
  autostart = true,
  callback = update_storage
})

---Package----------------------
local text4 = '<span color="' ..
    color.blueish_white .. '" font="Ubuntu Nerd Font 16">' .. '  :   ' .. '2634' .. '</span>'
local icon4 = '<span color="' .. color.red .. '" font="Ubuntu Nerd Font bold 17">' .. '󰏖' .. '</span>'

local package_count = wibox.widget {
  markup = icon4 .. text4,
  font = "Ubuntu Nerd Font Bold 14",
  widget = wibox.widget.textbox,
  fg = color.white,
}

local packages_text = wibox.widget {
  package_count,
  widget = wibox.container.margin,
  top = dpi(6),
  bottom = dpi(6),
  right = dpi(9),
  left = dpi(25),
  -- forced_height = dpi(40)
}

awful.spawn.easy_async_with_shell([[dnf list installed | wc -l]], function(out)
  local str = string.gsub(out, "%s+", "")

  package_count.markup = icon4 .. '<span color="' ..
      color.blueish_white .. '" font="Ubuntu Nerd Font 16">' .. '  :   ' .. str .. '</span>'
end)



local Sys_info = wibox.widget {
  {
    {
      {
        ram_text,
        cpu_text,
        storage_text,
        packages_text,
        layout = wibox.layout.fixed.vertical
      },
      widget = wibox.container.place,
      halign = 'left'
    },
    widget = wibox.container.background,
    bg = color.background_lighter,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 10)
    end,

  },
  widget = wibox.container.margin,
  top = dpi(12),
  bottom = dpi(12),
  left = dpi(0),
  right = dpi(12),
  forced_width = dpi(220)
}

local main = wibox.widget {
  web_launch,
  Sys_info,
  layout = wibox.layout.fixed.horizontal
}

return main
