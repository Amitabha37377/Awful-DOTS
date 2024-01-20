local user = require("user")

local _M = {
	terminal = user.terminal,
	editor   = user.editor
}

_M.editor_cmd = _M.terminal .. ' -e ' .. _M.editor
_M.manual_cmd = _M.terminal .. ' -e man awesome'

return _M
