local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local Gio = require("lgi").Gio
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local color = require("themes.colors")
local iconTheme = require("lgi").require("Gtk", "3.0").IconTheme.get_default()
local helpers = require('helpers')
-- local sidebar = require('ui.launcher.sidebar')
-- Widgets



local noa = 6 --Number of apps to be shown at once

local horizonta_separator = wibox.widget {
	orientation = 'horizontal',
	forced_height = dpi(1.5),
	forced_width = dpi(1.5),
	span_ratio = 0.95,
	widget = wibox.widget.separator,
	color = color.fg_normal,
	border_color = color.fg_normal,
	opacity = 0.55
}


function hovercursor(widget)
	local oldcursor, oldwibox
	widget:connect_signal("mouse::enter", function()
		local wb = mouse.current_wibox
		if wb == nil then return end
		oldcursor, oldwibox = wb.cursor, wb
		wb.cursor = "hand2"
	end)
	widget:connect_signal("mouse::leave", function()
		if oldwibox then
			oldwibox.cursor = oldcursor
			oldwibox = nil
		end
	end)
	return widget
end

local launcherdisplay = wibox {
	width = dpi(530),
	height = dpi(570),
	bg = color.bg_dark,
	ontop = true,
	visible = false,
	border_width = dpi(3),
	border_color = color.bg_normal,
	shape = helpers.rrect(6)
}

local prompt = wibox.widget.textbox()

local entries = wibox.widget {
	homogeneous = false,
	expand = true,
	forced_num_cols = 1,
	layout = wibox.layout.grid
}

launcherdisplay:setup
-- { sidebar,
-- { layout = wibox.layout.fixed.horizontal,
		{
			{
				{
					{
						{
							{
								prompt,
								widget = wibox.container.margin,
								margins = dpi(6),
								forced_width = dpi(400)
							},
							bg = color.bg_light,
							widget = wibox.container.background,
							shape = function(cr, width, height)
								gears.shape.rounded_rect(cr, width, height, 5)
							end,

						},
						widget = wibox.container.margin,
						margins = dpi(10)
					},
					{

						{
							horizonta_separator,
							entries,
							layout = wibox.layout.fixed.vertical
						},
						margins = dpi(10),
						widget = wibox.container.margin
					},
					layout = wibox.layout.fixed.vertical
				},
				widget = wibox.container.margin,
				margins = dpi(15),
			},
			widget = wibox.container.background,
			bg = color.bg_dark,
			shape = helpers.part_rrect(false, true, true, false, 6),
		}
-- }
-- Functions

local function next()
	if entryindex ~= #filtered then
		entries:get_widgets_at(entryindex, 1)[1].bg = nil
		entries:get_widgets_at(entryindex + 1, 1)[1].bg = color.bg_normal
		entryindex = entryindex + 1
		if entryindex > startindex + (noa - 1) then
			entries:get_widgets_at(entryindex - noa, 1)[1].visible = false
			entries:get_widgets_at(entryindex, 1)[1].visible = true
			startindex = startindex + 1
		end
	end
	move = true
end

local function back()
	if entryindex ~= 1 then
		entries:get_widgets_at(entryindex, 1)[1].bg = nil
		entries:get_widgets_at(entryindex - 1, 1)[1].bg = color.bg_normal
		entryindex = entryindex - 1
		if entryindex < startindex then
			entries:get_widgets_at(entryindex + noa, 1)[1].visible = false
			entries:get_widgets_at(entryindex, 1)[1].visible = true
			startindex = startindex - 1
		end
	end
	move = true
end

local function gen()
	local entries = {}
	for _, entry in ipairs(Gio.AppInfo.get_all()) do
		if entry:should_show() then
			local name = entry:get_name():gsub("&", "&amp;"):gsub("<", "&lt;"):gsub("'", "&#39;")
			local icon = entry:get_icon()
			local path
			if icon then
				path = icon:to_string()
				if not path:find("/") then
					local icon_info = iconTheme:lookup_icon(path, dpi(48), 0)
					local p = icon_info and icon_info:get_filename()
					path = p
				end
			end
			local description = entry:get_description() or "No description available"
			table.insert(
				entries,
				{ name = name, appinfo = entry, description = description, icon = path or '' }
			)

			-- table.insert(, description
			--   entries,
			--   { name = name, appinfo = entry }
			-- )
		end
	end
	return entries
end

local function filter(cmd)
	filtered = {}
	regfiltered = {}

	-- Filter entries

	for _, entry in ipairs(unfiltered) do
		if entry.name:lower():sub(1, cmd:len()) == cmd:lower() then
			table.insert(filtered, entry)
		elseif entry.name:lower():match(cmd:lower()) then
			table.insert(regfiltered, entry)
		end
	end

	-- Sort entries

	table.sort(filtered, function(a, b) return a.name:lower() < b.name:lower() end)
	table.sort(regfiltered, function(a, b) return a.name:lower() < b.name:lower() end)

	-- Merge entries

	for i = 1, #regfiltered do
		filtered[#filtered + 1] = regfiltered[i]
	end

	-- Clear entries

	entries:reset()

	-- Fix position

	entryindex, startindex = 1, 1

	-- Add filtered entries

	for i, entry in ipairs(filtered) do
		local widget = hovercursor(wibox.widget {
			{
				{
					{
						{
							image = entry.icon,
							clip_shape = function(cr, width, height)
								gears.shape.rounded_rect(cr, width, height, 10)
							end,
							forced_height = dpi(50),
							forced_width = dpi(50),
							valign = 'center',
							widget = wibox.widget.imagebox
						},

						{
							{
								{
									-- text = entry.name,
									markup = '<span color="' ..
											color.lightblue .. '" font="Ubuntu Nerd Font 15 bold">' .. entry.name .. '</span>',

									widget = wibox.widget.textbox,
									forced_height = dpi(30),
									valign = 'center',
								},
								{
									markup = '<span color="' ..
											color.fg_normal .. '" font="Ubuntu Nerd Font 13">' .. entry.description .. '</span>',
									widget = wibox.widget.textbox,
									valign = 'center',
									-- forced_height = dpi(50)
								},

								layout = wibox.layout.fixed.vertical,
							},
							widget = wibox.container.margin,
							left = dpi(15),
							bottom = dpi(5),
							forced_height = dpi(55)
						},
						layout = wibox.layout.fixed.horizontal
					},

					margins = dpi(12),
					forced_height = dpi(77),
					forced_width = dpi(400),
					widget = wibox.container.margin
				},
				-- {
				-- 	horizonta_separator,
				-- 	widget = wibox.container.margin,
				-- 	-- margins = dpi(5),
				-- },
				layout = wibox.layout.fixed.vertical
			},
			buttons = {
				awful.button({}, 1, function()
					if entryindex == i then
						local entry = filtered[entryindex]
						entry.appinfo:launch()
						awful.keygrabber.stop()
						launcherdisplay.visible = false
					else
						entries:get_widgets_at(entryindex, 1)[1].bg = nil
						entryindex = i
						entries:get_widgets_at(entryindex, 1)[1].bg = color.bg_normal
					end
				end),
				awful.button({}, 3, function()
					awful.keygrabber.stop()
					launcherdisplay.visible = false
				end),
				awful.button({}, 4, function()
					back()
				end),
				awful.button({}, 5, function()
					next()
				end)
			},
			widget = wibox.container.background,
			shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, 5)
			end,

		})

		if startindex <= i and i <= startindex + (noa - 1) then
			widget.visible = true
		else
			widget.visible = false
		end

		entries:add(widget)

		if i == entryindex then
			widget.bg = color.bg_normal
		end
	end

	collectgarbage("collect")
end

local function open()
	-- Reset variables

	startindex, entryindex, move = 1, 1, false

	-- Get entries

	unfiltered = gen()
	filter("")

	-- Prompt

	awful.prompt.run {
		-- prompt = "Search: ",
		prompt = '<span color="' ..
				color.fg_normal .. '" font="Ubuntu Nerd Font Bold 16">' .. '  : ' .. '</span>',
		textbox = prompt,
		done_callback = function()
			launcherdisplay.visible = false
		end,
		changed_callback = function(cmd)
			if move == false then
				filter(cmd)
			else
				move = false
			end
		end,
		exe_callback = function(cmd)
			local entry = filtered[entryindex]
			if entry then
				entry.appinfo:launch()
			else
				awful.spawn.with_shell(cmd)
			end
		end,
		keypressed_callback = function(_, key)
			if key == "Down" then
				next()
			elseif key == "Up" then
				back()
			end
		end
	}
end

awesome.connect_signal("widget::launcher", function()
	open()

	launcherdisplay.visible = not launcherdisplay.visible

	awful.placement.centered(
		launcherdisplay,
		{
			parent = awful.screen.focused(),
			margins = { left = dpi(0), top = dpi(250) }
		}
	)
end)

