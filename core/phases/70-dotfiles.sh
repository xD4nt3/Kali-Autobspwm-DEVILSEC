#!/usr/bin/env bash
# Phase 70 · Deploy DEVILSEC dotfiles and themes
set -uo pipefail
source "$DEVILSEC_ROOT/core/forge.sh"

# Backup any existing configuration we are about to replace
forge::step "Backing up existing dotfiles (if any)"
for target in \
    "$HOME/.config/bspwm" \
    "$HOME/.config/sxhkd" \
    "$HOME/.config/polybar" \
    "$HOME/.config/picom" \
    "$HOME/.config/kitty" \
    "$HOME/.config/rofi" \
    "$HOME/.config/dunst" \
    "$HOME/.config/fastfetch" \
    "$HOME/.config/starship.toml" \
    "$HOME/.zshrc"; do
    forge::backup "$target"
done

# Deploy ~/.config/* from the project's `config` dir
forge::step "Deploying ~/.config/* from project"
mkdir -p "$HOME/.config"
for d in bspwm sxhkd polybar picom kitty rofi dunst fastfetch; do
    src="$DEVILSEC_ROOT/config/$d"
    dst="$HOME/.config/$d"
    if [[ -d "$src" ]]; then
        rm -rf "$dst"
        cp -r "$src" "$dst"
        # All shell scripts inside config must be executable
        find "$dst" -type f \( -name "*.sh" -o -name "bspwmrc" -o -name "launch" \) -exec chmod +x {} \;
        forge::ok "deployed ~/.config/$d"
    fi
done

# Single files
for f in starship.toml; do
    src="$DEVILSEC_ROOT/config/$f"
    [[ -f "$src" ]] && cp "$src" "$HOME/.config/$f"
done

# zsh config
if [[ -f "$DEVILSEC_ROOT/config/zsh/zshrc" ]]; then
    cp "$DEVILSEC_ROOT/config/zsh/zshrc" "$HOME/.zshrc"
    forge::ok "deployed ~/.zshrc"
fi

# Wallpapers
WALL_DIR="$HOME/Pictures/devilsec-wallpapers"
mkdir -p "$WALL_DIR"
if [[ -d "$DEVILSEC_ROOT/themes/wallpapers" ]]; then
    cp -r "$DEVILSEC_ROOT/themes/wallpapers"/* "$WALL_DIR/" 2>/dev/null || true
    forge::ok "wallpapers placed in $WALL_DIR"
fi

# Default wallpaper symlink (prefer limbo.png if it exists)
if [[ -f "$WALL_DIR/limbo.png" ]]; then
    DEFAULT_WALL="$WALL_DIR/limbo.png"
else
    DEFAULT_WALL=$(find "$WALL_DIR" -type f \( -name "*.png" -o -name "*.jpg" \) | head -1)
fi
if [[ -n "${DEFAULT_WALL:-}" ]]; then
    ln -sf "$DEFAULT_WALL" "$HOME/.config/devilsec-wallpaper"
    # Apply immediately if X is running and feh is present
    if [[ -n "${DISPLAY:-}" ]] && command -v feh >/dev/null 2>&1; then
        feh --no-fehbg --bg-fill "$DEFAULT_WALL" 2>/dev/null || true
    fi
    forge::ok "default wallpaper: $(basename "$DEFAULT_WALL")"
fi

# Rofi themes
ROFI_THEME_DIR="$HOME/.config/rofi/themes"
mkdir -p "$ROFI_THEME_DIR"
if [[ -d "$DEVILSEC_ROOT/themes/rofi-themes" ]]; then
    cp "$DEVILSEC_ROOT/themes/rofi-themes"/*.rasi "$ROFI_THEME_DIR/" 2>/dev/null || true
fi

# Polybar alternate themes
POLY_THEME_DIR="$HOME/.config/polybar/themes"
mkdir -p "$POLY_THEME_DIR"
if [[ -d "$DEVILSEC_ROOT/themes/polybar-themes" ]]; then
    cp -r "$DEVILSEC_ROOT/themes/polybar-themes"/* "$POLY_THEME_DIR/" 2>/dev/null || true
fi

# Make all script directories executable
chmod -R +x "$HOME/.config/polybar"/*.sh 2>/dev/null || true
chmod -R +x "$HOME/.config/polybar/scripts" 2>/dev/null || true
chmod +x "$HOME/.config/bspwm/bspwmrc" 2>/dev/null || true
chmod +x "$HOME/.config/bspwm/scripts"/* 2>/dev/null || true

# Pictures and assets
mkdir -p "$HOME/.local/share/devilsec"
if [[ -d "$DEVILSEC_ROOT/assets" ]]; then
    cp -r "$DEVILSEC_ROOT/assets"/* "$HOME/.local/share/devilsec/" 2>/dev/null || true
fi

# fastfetch logo is already in config/fastfetch/logo.txt — it gets deployed
# along with the rest of the fastfetch config above.

# Mark this user as DEVILSEC-managed so styx can detect it
touch "$HOME/.config/devilsec.session"
echo "version=1.1.0" >> "$HOME/.config/devilsec.session"
echo "installed=$(date -Iseconds)" >> "$HOME/.config/devilsec.session"

forge::ok "Dotfiles deployed"
