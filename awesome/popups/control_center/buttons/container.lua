local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--Custom Modules
local color = require("popups.color")

local function create_button(icon, mtop, mbottom, mleft, mright, bg, btn_height, btn_width)
	local container = wibox.widget {
		{
			{
				image = os.getenv("HOME") .. "/.config/awesome/popups/control_center/assets/" .. icon .. ".png",
				widget = wibox.widget.imagebox,
				resize = true,
				shape = function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, 20)
				end,

			},
			widget = wibox.container.margin,
			top = dpi(mtop),
			bottom = dpi(mbottom),
			left = dpi(mleft),
			right = dpi(mright),
		},
		widget = wibox.container.background,
		bg = bg,
		shape = function(cr, width, height)
			gears.shape.rounded_bar(cr, dpi(btn_width), dpi(btn_height))
		end
	}

	return container
end

local containers = {
	wifi = create_button("wifi", 15, 15, 14, 13, color.blue, 50, 52),
	bluetooth = create_button("bluetooth", 12, 12, 10, 10, color.grey, 50, 52),
	dark = create_button("dark", 15, 15, 16, 16, color.grey, 54, 56),
	silent = create_button("silent", 15, 15, 18, 14, color.grey, 54, 56),
	dnd = create_button("dnd", 15, 15, 18, 14, color.grey, 50, 52)
}

return containers
