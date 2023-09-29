return{
	{'romgrk/barbar.nvim',
		dependencies = {
			'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
			'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
		},
		init = function() vim.g.barbar_auto_setup = false end,
		opts = {
			minimum_padding = 1,
			maximum_padding = 1,
			sidebar_filetypes = {
				NvimTree = true,
				undotree = { text = 'undotree' },
				['neo-tree'] = { event = 'BufWipeout' },
				Outline = { event = 'BufWinLeave', text = 'symbols-outline' },
			},
			animation = false

		},
		version = '^1.0.0', -- optional: only update when a new 1.x version is released
	},

}
