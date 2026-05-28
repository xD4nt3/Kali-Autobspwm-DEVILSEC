#!/usr/bin/env bash
# Phase 99 · Postflight & sealing
set -uo pipefail
source "$DEVILSEC_ROOT/core/forge.sh"

forge::step "Updating font cache"
sudo fc-cache -fr >/dev/null 2>&1 || true

forge::step "Updating desktop entry cache"
sudo update-desktop-database >/dev/null 2>&1 || true

# Make sure the bspwm session file is selectable in display managers
DM_SESSION=/usr/share/xsessions/bspwm.desktop
if [[ ! -f "$DM_SESSION" ]]; then
    sudo tee "$DM_SESSION" >/dev/null <<'EOF'
[Desktop Entry]
Name=bspwm
Comment=Binary space partitioning WM (DEVILSEC)
Exec=bspwm
TryExec=bspwm
Type=Application
DesktopNames=bspwm
EOF
    forge::ok "bspwm session registered"
fi

# Final sanity report
forge::step "Sanity report:"
for c in bspwm sxhkd polybar picom rofi dunst kitty zsh starship \
         nxc bloodyAD certipy bloodhound-python kerbrute pipx; do
    if command -v "$c" &>/dev/null; then
        ver=$("$c" --version 2>/dev/null | head -1 || echo "")
        forge::ok "$c — ${ver:-installed}"
    else
        forge::warn "$c — missing"
    fi
done

forge::ok "Sealing complete"
