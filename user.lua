local user = {

	--Profile
	name         = "Shehejek",
	host         = "awesomewm",
	user_img     = os.getenv("HOME") .. "/.config/awesome/assets/user.png",

	-- Default apps
	terminal     = "wezterm",
	file_manager = "thunar",
	browser      = "firefox",
	editor       = "nvim",

	wallpaper    = os.getenv("HOME") .. "/.config/awesome/assets/wave.png",
	icon_path    = os.getenv("HOME") .. '/.icons/Tela/scalable/apps/',
	-- icon_path    = os.getenv("HOME") .. '/.icons/Papirus/48x48/apps/',

	theme        = "tokyonight", --[[available_themes:tokyonight, biscuit_dark, adwaita, oxocarbon]]
	bar_floating = true,
}

return user
