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
	-- Dividir panel horizontalmente (uno arriba, otro abajo)
	{
		key = "-",
		mods = "ALT",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- Dividir panel verticalmente (uno a la izquierda, otro a la derecha)
	{
		key = "\\",
		mods = "ALT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Desactivar Ctrl+Shift+D para evitar cerrar paneles accidentalmente
	{
		key = "d",
		mods = "CTRL|SHIFT",
		action = act.DisableDefaultAssignment,
	},
}

-- Decoraciones de ventana
config.window_decorations = "NONE"

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

-- NVim optimizaciones
if wezterm.target_triple:find("windows") then
	config.term = "xterm-256color"
else
	config.term = "wezterm"
end
config.enable_csi_u_key_encoding = true

-- Undercurl support (LSP diagnostics, spelling)
config.underline_thickness = 2
config.underline_position = -2

-- Scrollback
config.scrollback_lines = 10000

-- Performance
config.max_fps = 240

-- Image support
config.enable_kitty_graphics = true

-- Input handling
config.use_dead_keys = false
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- Fuente
config.font = wezterm.font("JetBrains Mono")
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }
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

-- Cursor
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- Configuración de Background
config.background = {
	{
		source = {
			File = wezterm.config_dir .. "/hacker-box.png",
		},
		hsb = {
			brightness = 0.02,
			saturation = 1.0,
		},
	},
}

config.colors = {
	-- Background
	foreground = "#53d1df", --#f3f6f9",

	-- Cursor
	cursor_bg = "red",
	cursor_fg = "#06080f",
	cursor_border = "#e0c15a",

	-- Selection
	selection_fg = "#f3f6f9",
	selection_bg = "#263356",

	-- Normal Colors
	ansi = {
		"#06080f", -- black
		"#cb7c94", -- red
		"#b7cc85", -- green
		"#ffe066", -- yellow
		"#7fb4ca", -- blue
		"#ff8dd7", -- magenta
		"#7aa89f", -- cyan
		"#f3f6f9", -- white
	},

	-- Bright Colors
	brights = {
		"#8a8fa3", -- black
		"#de8fa8", -- red
		"#d1e8a9", -- green
		"#fff7b1", -- yellow
		"#a3d4d5", -- blue
		"#ffaeea", -- magenta
		"#7fb4ca", -- cyan
		"#f3f6f9", -- white
	},
}
return config
