-- Verificación de la configuración de WezTerm sin WezTerm.
-- Uso: nvim -l tests/config_check.lua (desde la raíz del repositorio)

local repo = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
local failures = 0

local function check(name, ok, detail)
	if ok then
		print("PASS  " .. name)
	else
		failures = failures + 1
		print("FAIL  " .. name .. (detail and ("  -> " .. detail) or ""))
	end
end

-- Stub del módulo wezterm
local function make_stub(opts)
	local action = setmetatable({}, {
		__index = function(t, name)
			local value = setmetatable({ action = name }, {
				__call = function(_, args)
					return { action = name, args = args }
				end,
			})
			rawset(t, name, value)
			return value
		end,
	})
	return {
		target_triple = opts.target_triple,
		config_dir = opts.config_dir,
		action = action,
		config_builder = function()
			return {}
		end,
		font = function(family, attrs)
			return { font = family, attrs = attrs }
		end,
		font_with_fallback = function(families, attrs)
			return { font_with_fallback = families, attrs = attrs }
		end,
		default_hyperlink_rules = function()
			return {}
		end,
		default_wsl_domains = function()
			return {
				{ name = "WSL:docker-desktop", distribution = "docker-desktop" },
				{ name = "WSL:Ubuntu-24.04", distribution = "Ubuntu-24.04" },
			}
		end,
	}
end

-- Evalúa el código fuente de la config con un stub y entorno dados
local function eval_config(source, opts)
	package.loaded["wezterm"] = nil
	package.preload["wezterm"] = function()
		return make_stub(opts)
	end
	local real_getenv = os.getenv
	os.getenv = function(key)
		if opts.env and opts.env[key] ~= nil then
			return opts.env[key]
		end
		if key == "LAZAROBOX_WSL_DISTRO" or key == "LAZAROBOX_OS" then
			return nil
		end
		return real_getenv(key)
	end
	local chunk, err = loadstring(source, "wezterm.lua")
	assert(chunk, err)
	local ok, result = pcall(chunk)
	os.getenv = real_getenv
	package.loaded["wezterm"] = nil
	assert(ok, result)
	return result
end

local function read_file(path)
	local f = assert(io.open(path, "r"))
	local s = f:read("*a")
	f:close()
	return s
end

local original = vim.fn.system({ "git", "-C", repo, "show", "HEAD:wezterm.lua" })
assert(vim.v.shell_error == 0, "git show HEAD:wezterm.lua falló")
local current = read_file(repo .. "/wezterm.lua")

local linux = "x86_64-unknown-linux-gnu"
local windows = "x86_64-pc-windows-msvc"

-- Directorios de config: uno con imagen y otro vacío
local with_img = vim.fn.tempname()
local without_img = vim.fn.tempname()
vim.fn.mkdir(with_img, "p")
vim.fn.mkdir(without_img, "p")
local f = assert(io.open(with_img .. "/hacker-box.png", "w"))
f:write("x")
f:close()

-- 1. Linux: la config resultante no cambia
for _, dir in ipairs({ with_img, without_img }) do
	local a = eval_config(original, { target_triple = linux, config_dir = dir })
	local b = eval_config(current, { target_triple = linux, config_dir = dir })
	check("linux: config idéntica a HEAD (config_dir=" .. dir .. ")", vim.deep_equal(a, b), vim.inspect(b):sub(1, 400))
end

-- 2. Windows
local w = eval_config(current, { target_triple = windows, config_dir = with_img })
check("windows: default_domain = WSL:Ubuntu-24.04", w.default_domain == "WSL:Ubuntu-24.04", tostring(w.default_domain))
check(
	"windows: font = JetBrainsMono Nerd Font",
	type(w.font) == "table" and w.font.font == "JetBrainsMono Nerd Font",
	vim.inspect(w.font)
)
check("windows: window_decorations = RESIZE", w.window_decorations == "RESIZE", tostring(w.window_decorations))
check("windows: term = xterm-256color", w.term == "xterm-256color", tostring(w.term))
check(
	"windows: background con imagen existente",
	type(w.background) == "table" and w.background[1].source.File == with_img .. "/hacker-box.png",
	vim.inspect(w.background)
)

local w_override = eval_config(current, {
	target_triple = windows,
	config_dir = with_img,
	env = { LAZAROBOX_WSL_DISTRO = "Debian" },
})
check(
	"windows: LAZAROBOX_WSL_DISTRO sobrescribe la distro",
	w_override.default_domain == "WSL:Debian",
	tostring(w_override.default_domain)
)

local w_noimg = eval_config(current, { target_triple = windows, config_dir = without_img })
check("windows: sin imagen no hay background", w_noimg.background == nil, vim.inspect(w_noimg.background))

-- LAZAROBOX_OS fuerza la plataforma; un valor desconocido se ignora
local forced_win = eval_config(current, { target_triple = linux, config_dir = with_img, env = { LAZAROBOX_OS = "windows" } })
check("override: LAZAROBOX_OS=windows en Linux usa config Windows", forced_win.window_decorations == "RESIZE", tostring(forced_win.window_decorations))

local forced_linux = eval_config(current, { target_triple = windows, config_dir = with_img, env = { LAZAROBOX_OS = "linux" } })
check(
	"override: LAZAROBOX_OS=linux en Windows usa config Linux",
	forced_linux.window_decorations == "NONE" and forced_linux.term == "wezterm" and forced_linux.default_domain == nil,
	vim.inspect({ forced_linux.window_decorations, forced_linux.term, forced_linux.default_domain })
)

local bogus = eval_config(current, { target_triple = windows, config_dir = with_img, env = { LAZAROBOX_OS = "mac" } })
check("override: valor desconocido se ignora y detecta solo", bogus.window_decorations == "RESIZE", tostring(bogus.window_decorations))

vim.fn.delete(with_img, "rf")
vim.fn.delete(without_img, "rf")

if failures > 0 then
	print(("\n%d check(s) FAILED"):format(failures))
	os.exit(1)
end
print("\nAll checks passed")
os.exit(0)
