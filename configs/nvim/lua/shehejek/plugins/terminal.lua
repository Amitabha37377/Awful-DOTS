return{
	'akinsho/toggleterm.nvim',
		version = "*",
		opts = {
			highlights = {
				-- highlights which map to a highlight group name and a table of it's values
				-- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
				Normal = {
					guibg = "none",
				},
				NormalFloat = {
					link = 'Normal'
				},
				FloatBorder = {
					guibg = "none",
				},
			},

		}
}
