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

-- Paleta Kanagawa Blur (alineada con lua/plugins/catppuccin.lua)
config.colors = {
	-- Texto principal: blue (cyan-azul) de la paleta nvim
	foreground = "#7fb4ca",
	background = "#191e28", -- base, por si falla la imagen de fondo

	-- Cursor
	cursor_bg = "#a4daa7", -- teal
	cursor_fg = "#191e28", -- base
	cursor_border = "#e0c15a", -- rosewater (gold)

	-- Selección
	selection_fg = "#f3f6f9", -- text
	selection_bg = "#263356", -- lavender

	-- Normal Colors
	ansi = {
		"#191e28", -- black     (base)
		"#cb7c94", -- red
		"#b7cc85", -- green
		"#ffe066", -- yellow
		"#7fb4ca", -- blue
		"#c99ad6", -- magenta   (mauve / keyword)
		"#7aa89f", -- cyan      (sky)
		"#f3f6f9", -- white     (text)
	},

	-- Bright Colors
	brights = {
		"#5c6170", -- bright black   (subtext0 / gray5)
		"#c4746e", -- bright red     (flamingo / variable)
		"#a4daa7", -- bright green   (teal / number)
		"#e0c15a", -- bright yellow  (rosewater / gold)
		"#a3b5d6", -- bright blue    (sapphire)
		"#b99bf2", -- bright magenta (pink / function)
		"#7fb4ca", -- bright cyan    (blue)
		"#f3f6f9", -- bright white   (text)
	},

	-- Bordes de panel para que combinen con surfaces de nvim
	split = "#232a40", -- crust
	tab_bar = {
		background = "#191e28",
		active_tab = {
			bg_color = "#232a36", -- surface1
			fg_color = "#7fb4ca",
		},
		inactive_tab = {
			bg_color = "#191e28",
			fg_color = "#5c6170",
		},
		inactive_tab_hover = {
			bg_color = "#1c212c", -- surface0
			fg_color = "#f3f6f9",
		},
		new_tab = {
			bg_color = "#191e28",
			fg_color = "#5c6170",
		},
		new_tab_hover = {
			bg_color = "#232a36",
			fg_color = "#a4daa7",
		},
	},
}
return config
