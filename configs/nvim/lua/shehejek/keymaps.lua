vim.keymap.set("n", "<leader>w", vim.cmd.Ex)

--Function for defining keymaps
local define_keymap = function(mode, key, action)
	vim.keymap.set(mode, key, function()
		vim.cmd(action)
	end)
end

--Neotree------------
define_keymap('n', '<leader>e', 'Neotree toggle')
define_keymap('n', '<leader>a', 'Neotree focus')

--Split Buffer-------
vim.keymap.set('n', '<leader>p', vim.cmd.vsplit)
vim.keymap.set('n', '<leader>l', vim.cmd.split)

--Movecursor---------
define_keymap('n', '<C-Left>', 'SmartCursorMoveLeft')
define_keymap('n', '<C-Right>', 'SmartCursorMoveRight')
define_keymap('n', '<C-Up>', 'SmartCursorMoveUp')
define_keymap('n', '<C-Down>', 'SmartCursorMoveDown')

--Telescope----------
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>s', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

--Terminal-----------
define_keymap('n', '<C-`>', 'ToggleTerm size=50 direction=vertical')
define_keymap('n', '<C-1>', 'ToggleTerm size=11 direction=horizontal')

--Move between tabs------
define_keymap('n', '<leader>1', "BufferGoto 1")
define_keymap('n', '<leader>2', "BufferGoto 2")
define_keymap('n', '<leader>3', "BufferGoto 3")

define_keymap('n', '<leader>5', "BufferGoto 5")
define_keymap('n', '<leader>6', "BufferGoto 6")
define_keymap('n', '<leader>7', "BufferGoto 7")
define_keymap('n', '<leader>8', "BufferGoto 8")

--Close Tab----------
define_keymap('n', '<leader>q', "BufferClose")


