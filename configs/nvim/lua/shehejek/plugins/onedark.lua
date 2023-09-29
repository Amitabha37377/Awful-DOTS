return {
	'navarasu/onedark.nvim',
	opts = {
		style = 'dark',
		transparent = true,
		term_colors = true,
		ending_tildes = false,
		cmp_itemkind_reverse = false,

		code_style = {
			comments = 'italic',
			keywords = 'none',
			functions = 'none',
			strings = 'none',
			variables = 'none'
		},

		lualine = {
			transparent = false,
		},

		-- Plugins Config --
		diagnostics = {
			darker = true,
			undercurl = true,
			background = false,
		},
	},
}
