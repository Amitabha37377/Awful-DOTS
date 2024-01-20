local user = require("user")
local color

local colorschemes = {
	biscuit_dark = require("themes.colors.biscuit_dark"),
	adwaita = require("themes.colors.adwaita"),
	yoru = require("themes.colors.yoru"),
	tokyonight = require("themes.colors.tokyonight"),
	oxocarbon = require("themes.colors.oxocarbon"),
	rosepine_dawn = require("themes.colors.rosepine_dawn"),
	latte = require("themes.colors.latte")
}

if user.theme == 'biscuit_dark' then
	color = colorschemes.biscuit_dark
elseif user.theme == 'adwaita' then
	color = colorschemes.adwaita
elseif user.theme == 'yoru' then
	color = colorschemes.yoru
elseif user.theme == 'oxocarbon' then
	color = colorschemes.oxocarbon
elseif user.theme == 'rosepine_dawn' then
	color = colorschemes.rosepine_dawn
elseif user.theme == 'latte' then
	color = colorschemes.latte
else
	color = colorschemes.tokyonight
end

return color
