local user = {

	--Profile
	name            = "Shehejek",
	host            = "awesomewm",
	user_img        = os.getenv("HOME") .. "/.config/awesome/assets/cat.jpg",

	-- Default apps
	terminal        = "wezterm",
	file_manager    = "thunar",
	browser         = "firefox",
	editor          = "nvim",

	-- wallpaper    = os.getenv("HOME") .. "/.config/awesome/assets/wave.png",
	icon_path       = os.getenv("HOME") .. '/.icons/Papirus/48x48/apps/',
	-- icon_path    = os.getenv("HOME") .. '/.icons/Tela/scalable/apps/',
	-- icon_path    = os.getenv("HOME") .. '/.icons/Zafiro-Icons-Dark-Blue-f/apps/scalable/',
	theme           = "tokyonight", --[[available_themes:tokyonight, biscuit_dark, adwaita, oxocarbon, yoru, latte]]
	topbar_floating = false,
	font            = "Ubuntu nerd font ",
}

user.dock_elements = {
	{ 'terminal',    user.terminal },
	{ user.browser,  user.browser },
	{ 'Thunar',      user.file_manager },
	{ 'telegram',    'telegram-desktop' },
	{ 'discord',     'flatpak run com.discordapp.Discord' },
	{ 'gimp' },
	{ 'code' },
	{ 'vokoscreenNG' }
}

return user
