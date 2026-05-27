#!/usr/bin/env bash
# Phase 10 · Base packages, build deps, fonts
set -uo pipefail
source "$DEVILSEC_ROOT/core/forge.sh"

forge::step "Installing base toolchain & libraries"
forge::apt_install \
    build-essential pkg-config cmake make gcc g++ git curl wget \
    ca-certificates gnupg lsb-release software-properties-common \
    python3 python3-pip python3-venv pipx jq unzip xz-utils \
    libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev \
    libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-keysyms1-dev \
    libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev libcairo2-dev \
    libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xtest0-dev \
    libxcb-xrm-dev libxcb-shape0-dev libuv1-dev libdbus-1-dev libgl-dev libegl-dev \
    libpcre2-dev libev-dev libpixman-1-dev libxext-dev libxinerama-dev libxrandr-dev

forge::step "Installing X / WM ecosystem"
forge::apt_install \
    xorg xinit xclip xdotool xinput xterm xsel scrot maim feh nitrogen \
    redshift dunst libnotify-bin playerctl pulseaudio pulseaudio-utils \
    pavucontrol acpi acpid upower brightnessctl \
    network-manager network-manager-gnome \
    lxappearance lxpolkit policykit-1-gnome \
    gvfs gvfs-backends thunar thunar-archive-plugin file-roller \
    bluetooth bluez blueman \
    fonts-cantarell fonts-firacode fonts-noto-color-emoji \
    fonts-jetbrains-mono fonts-font-awesome

forge::step "Installing Nerd Fonts (JetBrainsMono, SymbolsOnly)"
NF_DIR="/usr/local/share/fonts/nerd-fonts"
if [[ ! -d "$NF_DIR" ]]; then
    sudo mkdir -p "$NF_DIR"
    tmp=$(mktemp -d)
    cd "$tmp"
    for font in JetBrainsMono NerdFontsSymbolsOnly; do
        forge::info "Downloading ${font}…"
        wget -q "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.zip" \
            && unzip -qo "${font}.zip" -d "${font}" || { forge::warn "Could not fetch ${font}"; continue; }
        sudo cp ${font}/*.ttf ${font}/*.otf "$NF_DIR" 2>/dev/null || true
    done
    cd /
    rm -rf "$tmp"
    sudo fc-cache -fr >/dev/null
    forge::ok "Nerd Fonts installed"
else
    forge::info "Nerd Fonts already present"
fi

forge::step "Ensuring pipx path is configured"
pipx ensurepath >/dev/null 2>&1 || true

forge::step "Creating /opt/devilsec hierarchy"
sudo mkdir -p /opt/devilsec/{bin,tools,wordlists,share}
sudo chown -R "$USER:$USER" /opt/devilsec

# Ensure /opt/devilsec/bin is on PATH (system-wide via /etc/profile.d)
PROFILE_FILE=/etc/profile.d/devilsec.sh
if [[ ! -f "$PROFILE_FILE" ]]; then
    sudo tee "$PROFILE_FILE" >/dev/null <<'EOF'
# DEVILSEC environment
export DEVILSEC_HOME=/opt/devilsec
case ":$PATH:" in
    *":$DEVILSEC_HOME/bin:"*) ;;
    *) export PATH="$DEVILSEC_HOME/bin:$PATH" ;;
esac
EOF
    sudo chmod 644 "$PROFILE_FILE"
    forge::ok "/opt/devilsec/bin added to system PATH"
fi

forge::ok "Base phase complete"
