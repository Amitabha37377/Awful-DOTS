return{
	'mrjones2014/smart-splits.nvim',
	opts = {
		ignored_filetypes = {
			'nofile',
			'quickfix',
			'prompt',
		},
		ignored_buftypes = { 'NvimTree' },
		default_amount = 3,
		at_edge = 'wrap',
		move_cursor_same_row = false,
		cursor_follows_swapped_bufs = false,
		resize_mode = {
			quit_key = '<ESC>',
			resize_keys = { 'h', 'j', 'k', 'l' },
			silent = false,
			hooks = {
				on_enter = nil,
				on_leave = nil,
			},
		},
		ignored_events = {
			'BufEnter',
			'WinEnter',
		},
		multiplexer_integration = nil,
		disable_multiplexer_nav_when_zoomed = true,
		kitty_password = nil,
		log_level = 'info',
	}
}
