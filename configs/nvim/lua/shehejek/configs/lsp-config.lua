local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

local kind_icons = {
	Text = "",
	Method = "󰆧",
	Function = "󰊕",
	Constructor = "",
	Field = "󰇽",
	Variable = "󰂡",
	Class = "󰠱",
	Interface = "",
	Module = "",
	Property = "󰜢",
	Unit = "",
	Value = "󰎠",
	Enum = "",
	Keyword = "󰌋",
	Snippet = "",
	Color = "󰏘",
	File = "󰈙",
	Reference = "",
	Folder = "󰉋",
	EnumMember = "",
	Constant = "󰏿",
	Struct = "",
	Event = "",
	Operator = "󰆕",
	TypeParameter = "󰅲",
}

-- You need to setup `cmp` after lsp-zero
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

--Puts parenthesis on selecting a function
cmp.event:on(
	'confirm_done',
	cmp_autopairs.on_confirm_done()
)

--cmp setups
cmp.setup({

	mapping = {
		-- `Enter` key to confirm completion
		['<CR>'] = cmp.mapping.confirm({ select = false }),

		-- Ctrl+Space to trigger completion menu
		['<C-Space>'] = cmp.mapping.complete(),

		-- Navigate between snippet placeholder
		['<C-f>'] = cmp_action.luasnip_jump_forward(),
		['<C-b>'] = cmp_action.luasnip_jump_backward(),
	},

	window = {
		completion = cmp.config.window.bordered({
			border = "double",
		}),
	},
	formatting = {
		format =
			function(entry, vim_item)
				local lspkind_ok, lspkind = pcall(require, "lspkind")
				if not lspkind_ok then
					-- From kind_icons array
					vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
					-- Source
					vim_item.menu = ({
						buffer = "[Buffer]",
						nvim_lsp = "[LSP]",
						luasnip = "[LuaSnip]",
						nvim_lua = "[Lua]",
						latex_symbols = "[LaTeX]",
					})[entry.source.name]
					vim_item.abbr = string.sub(vim_item.abbr, 1, 20)
					return vim_item
				else
					-- From lspkind
					return lspkind.cmp_format()(entry, vim_item)
				end
			end
	},

	sources = cmp.config.sources {
		{ name = "nvim_lsp", priority = 1000 },
		{ name = "luasnip",  priority = 750 },
		{ name = "buffer",   priority = 500 },
		{ name = "path",     priority = 250 },
	},

	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},

})



lsp.set_preferences({
	suggest_lsp_servers = false,
	sign_icons = {
		error = '',
		warn = '',
		hint = '󰰂',
		info = ''
	}
})

lsp.setup()

vim.diagnostic.config({
	virtual_text = true
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		-- delay update diagnostics
		update_in_insert = true,
	}
)

--Autoformatting on save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
