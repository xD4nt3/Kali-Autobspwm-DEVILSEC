#!/usr/bin/env bash
# Phase 80 · Install 'styx' control panel + custom commands + helpers
set -uo pipefail
source "$DEVILSEC_ROOT/core/forge.sh"

forge::step "Installing 'styx' control panel"
sudo cp "$DEVILSEC_ROOT/scripts/system/styx" /opt/devilsec/bin/styx
sudo chmod +x /opt/devilsec/bin/styx

forge::step "Installing styx modules"
sudo mkdir -p /opt/devilsec/share/styx
sudo cp -r "$DEVILSEC_ROOT/scripts/system/styx-modules"/* /opt/devilsec/share/styx/
sudo chmod +x /opt/devilsec/share/styx/*.sh

forge::step "Installing DEVILSEC helper binaries"
for tool in devilsec-opacity devilsec-keyboard devilsec-kitty-do devilsec-picom-watchdog; do
    if [[ -f "$DEVILSEC_ROOT/scripts/system/$tool" ]]; then
        sudo install -m 0755 "$DEVILSEC_ROOT/scripts/system/$tool" "/opt/devilsec/bin/$tool"
        forge::ok "  ▸ $tool"
    fi
done

forge::step "Installing custom commands"
for cmd in "$DEVILSEC_ROOT/scripts/commands"/*; do
    [[ -f "$cmd" ]] || continue
    name=$(basename "$cmd")
    sudo install -m 0755 "$cmd" "/opt/devilsec/bin/$name"
done
count=$(ls "$DEVILSEC_ROOT/scripts/commands" 2>/dev/null | wc -l)
forge::ok "  ▸ $count custom commands installed"

forge::step "Installing visual helpers"
sudo cp -r "$DEVILSEC_ROOT/scripts/visual"/* /opt/devilsec/bin/ 2>/dev/null || true
sudo chmod +x /opt/devilsec/bin/* 2>/dev/null || true

# Ensure xdotool, xprop, setxkbmap are installed (needed by helpers)
forge::step "Installing dependencies for opacity/keyboard/kitty-tabs helpers"
missing=()
command -v xdotool >/dev/null 2>&1 || missing+=(xdotool)
command -v xprop >/dev/null 2>&1 || missing+=(x11-utils)
command -v setxkbmap >/dev/null 2>&1 || missing+=(x11-xkb-utils)
if (( ${#missing[@]} > 0 )); then
    forge::apt_install "${missing[@]}"
fi

forge::ok "'styx' is installed. Run it any time:  styx"
forge::hint "Try Super+Alt+S for the graphical control panel"
