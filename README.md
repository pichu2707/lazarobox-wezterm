![LazaroWezTerm](./lazaro-wezterm.png)

# 🟥 LazaroBox WezTerm

```text
[ LZBOX TERM ] :: render layer
```

> A cyberpunk-inspired WezTerm configuration designed to match the LazaroBox ecosystem.

Optimized for color fidelity, transparency, and terminal-native workflows.

---

## Philosophy

The terminal is not just a shell — it's the canvas.

This configuration focuses on:

Accurate color reproduction (Neovim parity)
Controlled contrast for readability
Minimal UI noise
Smooth rendering in transparent environments

## Features

- LazaroBox color palette integration
- Transparent background tuning
- Optimized font rendering
- Cursor + selection visibility improvements
- Clean UI (no unnecessary decorations)

## Installation

Clone the repository:

```bash
git clone https://github.com/pichu2707/lazarobox-wezterm ~/.config/wezterm
```

Or manually copy:

```bash
~/.config/wezterm/wezterm.lua
```

### Windows (WSL)

The same config works on Windows and opens your WSL distro by default.

1. Install WezTerm and the [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads):

```powershell
winget install wez.wezterm
```

2. Clone the repository from PowerShell:

```powershell
git clone https://github.com/pichu2707/lazarobox-wezterm "$env:USERPROFILE\.config\wezterm"
```

3. (Optional) Pick the WSL distro. By default the first distro that is not `docker-desktop` is used:

```powershell
setx LAZAROBOX_WSL_DISTRO "Ubuntu-24.04"
```

### Platform detection

The config detects Linux or Windows automatically, so the same repository works on both without changes. To force a platform, set `LAZAROBOX_OS` to `linux` or `windows` (any other value is ignored):

```bash
export LAZAROBOX_OS=linux   # Linux shell
```

```powershell
setx LAZAROBOX_OS "windows" # Windows
```

> **Note:** on Windows, ConPTY strips kitty graphics and undercurl escape sequences, so images and undercurl inside WSL won't render without WezTerm multiplexing.

## Configuration

This setup includes:

Custom color scheme aligned with LazaroBox.nvim
Transparency settings for compositors
Font + rendering tweaks

Example snippet:

```lua
return {
  color_scheme = "LazaroBox",
  window_background_opacity = 0.9,
  enable_tab_bar = false,
}
```

## Ecosystem

Part of the LazaroBox system:

- 🖥️ Neovim → https://github.com/pichu2707/lazarobox-nvim
- 🟧 WezTerm → this repository
- 🔗 Recommended Setup

For best results:

- Neovim → LazaroBox.nvim
- Terminal → WezTerm config
- Compositor → transparency enabled

This ensures consistent color rendering across the entire stack.

## Design Notes

Colors are tuned to match Neovim highlights exactly
Background opacity is balanced to avoid washout
UI elements are minimized to keep focus on content

## Author

Javi Lázaro
https://www.javilazaro.es

📜 License

MIT
