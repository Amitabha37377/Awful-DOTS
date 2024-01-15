local wezterm = require "wezterm"
local act = wezterm.action

local define_binding = function(define_key, define_action)
	return {
		mods = "ALT",
		key = define_key,
		action = define_action
	}
end

local define_binding_with_mod = function(define_mod, define_key, define_action)
	return {
		mods = define_mod,
		key = define_key,
		action = define_action
	}
end

local binds = {

	------------------------------------------
	--Panes-----------------------------------
	------------------------------------------

	-- Split Panes
	define_binding("`", act.SplitPane {
		direction = "Right",
		size = { Percent = 30 },
	}),

	define_binding("Tab", act.SplitPane {
		direction = "Down",
		size = { Percent = 30 }
	}),
	define_binding("Enter", act.SplitHorizontal { domain = 'CurrentPaneDomain' }),
	define_binding("\\", act.SplitVertical { domain = 'CurrentPaneDomain' }),
	define_binding("w", act.CloseCurrentPane { confirm = true }),

	-- Focus on pane by direction
	define_binding("LeftArrow", act.ActivatePaneDirection 'Left'),
	define_binding("RightArrow", act.ActivatePaneDirection 'Right'),
	define_binding("UpArrow", act.ActivatePaneDirection 'Up'),
	define_binding("DownArrow", act.ActivatePaneDirection 'Down'),

	-----------------------------------------
	--Tabs-----------------------------------
	-----------------------------------------
	define_binding("t", act.SpawnTab 'CurrentPaneDomain'),
	define_binding("q", act.CloseCurrentTab { confirm = true }),

	-- Focus on Tabs
	define_binding("1", act.ActivateTab(0)),
	define_binding("2", act.ActivateTab(1)),
	define_binding("3", act.ActivateTab(2)),
	define_binding("4", act.ActivateTab(3)),
	define_binding("5", act.ActivateTab(4)),
	define_binding("6", act.ActivateTab(5)),
	define_binding("7", act.ActivateTab(6)),
	define_binding("8", act.ActivateTab(7)),
	--
	define_binding_with_mod("CTRL|ALT", "UpArrow", act.ActivateLastTab),
	define_binding_with_mod("CTRL|ALT", "DownArrow", act.ActivateLastTab),

	--Move tab
	define_binding_with_mod("CTRL|ALT", "1", act.MoveTab(0)),
	define_binding_with_mod("CTRL|ALT", "2", act.MoveTab(1)),
	define_binding_with_mod("CTRL|ALT", "3", act.MoveTab(2)),
	define_binding_with_mod("CTRL|ALT", "4", act.MoveTab(3)),
	define_binding_with_mod("CTRL|ALT", "5", act.MoveTab(4)),
	define_binding_with_mod("CTRL|ALT", "6", act.MoveTab(5)),
	define_binding_with_mod("CTRL|ALT", "7", act.MoveTab(6)),
	define_binding_with_mod("CTRL|ALT", "8", act.MoveTab(7)),
	--
	define_binding_with_mod("CTRL|ALT", "LeftArrow", act.MoveTabRelative(-1)),
	define_binding_with_mod("CTRL|ALT", "RightArrow", act.MoveTabRelative(1)),

	----------------------------------------
	--Copy/Paste----------------------------
	----------------------------------------
	define_binding("c", act.CopyTo 'ClipboardAndPrimarySelection'),
	define_binding("v", act.PasteFrom 'PrimarySelection'),
	define_binding("v", act.PasteFrom 'Clipboard'),

	-----------------------------------------
	--Change Font Size-----------------------
	-----------------------------------------
	define_binding("+", act.IncreaseFontSize),
	define_binding("-", act.DecreaseFontSize),
	define_binding("*", act.ResetFontSize),

}

return binds
