local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

config.keys = {
	{ key = "8", mods = "CTRL", action = act.PaneSelect },
	{
		key = "9",
		mods = "CTRL",
		action = act.PaneSelect({
			alphabet = "1234567890",
		}),
	},
	{
		key = "0",
		mods = "CTRL",
		action = act.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
}

-- Decoraciones de ventana
config.window_decorations = "RESIZE"

-- Configuración de ventana
config.adjust_window_size_when_changing_font_size = false
config.initial_cols = 120
config.initial_rows = 30

-- Padding de la ventana
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

-- Fuente
config.font = wezterm.font("JetBrains Mono", {
	harfbuzz_features = { "calt=1", "clig=1", "liga=1" },
})
config.font_size = 16.0

-- Ocultar la barra de pestañas si solo hay una
config.hide_tab_bar_if_only_one_tab = true

-- Habilitar clic en enlaces (Ctrl+Click para abrir)
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Añadir regla adicional para localhost con puertos
table.insert(config.hyperlink_rules, {
	regex = [[\blocalhost:\d+\b]],
	format = "http://$0",
})

-- Mouse bindings para abrir enlaces
config.mouse_bindings = {
	-- Ctrl+Click abre enlaces
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
}

-- Configuración de Background
config.background = {
	{
		source = {
			File = "\\\\wsl$\\Ubuntu\\home\\pichu\\.config\\wezterm\\hacker-box.png",
		},
		hsb = {
			brightness = 0.15,
			saturation = 1.0,
		},
	},
}

-- Opacidad de la ventana (0.0 a 1.0)
config.window_background_opacity = 0.95
return config
