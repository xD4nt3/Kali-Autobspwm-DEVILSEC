#!/usr/bin/env bash
# Phase 20 · Window manager stack
set -uo pipefail
source "$DEVILSEC_ROOT/core/forge.sh"

forge::step "Installing window manager stack"
forge::apt_install \
    bspwm sxhkd polybar rofi dunst \
    picom \
    kitty \
    bat lsd fzf zoxide ripgrep fd-find tree \
    neovim tmux

# Many Debian builds of picom are old; build the modern (yshui) picom from source
# only if the apt one is older than 11.0.
PICOM_VER=$(picom --version 2>/dev/null | awk '/^v?[0-9]/{print; exit}' | tr -d 'v' | head -1 | awk '{print $1}')
PICOM_MAJOR=${PICOM_VER%%.*}
PICOM_MAJOR=${PICOM_MAJOR:-0}

if (( PICOM_MAJOR < 11 )); then
    forge::step "Building picom (yshui) from source for modern blur & animations"
    forge::apt_install meson ninja-build libdrm-dev libxcb-glx0-dev libgl-dev libegl-dev \
        libepoxy-dev uthash-dev
    tmp=$(mktemp -d)
    git clone --depth=1 https://github.com/yshui/picom.git "$tmp/picom" 2>/dev/null || true
    if [[ -d "$tmp/picom" ]]; then
        cd "$tmp/picom"
        meson setup --buildtype=release build >/dev/null
        ninja -C build >/dev/null 2>&1 || ninja -C build
        sudo ninja -C build install
        cd /
        rm -rf "$tmp"
        forge::ok "picom (latest) installed in /usr/local"
    else
        forge::warn "Could not clone picom; sticking with apt version"
    fi
else
    forge::info "picom $PICOM_VER already modern enough"
fi

# Polybar from apt is usually current on Kali (>= 3.7) — verify
PB_VER=$(polybar --version 2>/dev/null | head -1 | awk '{print $2}')
forge::info "polybar version: ${PB_VER:-unknown}"

# Rofi check for image support (needed for our themes)
if rofi -dump-config 2>/dev/null | grep -q 'show-icons'; then
    forge::ok "rofi has icon support"
fi

forge::ok "Window manager stack ready"
