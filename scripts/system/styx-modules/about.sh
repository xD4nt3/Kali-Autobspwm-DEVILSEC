#!/usr/bin/env bash
V=$(awk -F= '/^version=/{print $2}' "$HOME/.config/devilsec.session" 2>/dev/null || echo "?")
I=$(awk -F= '/^installed=/{print $2}' "$HOME/.config/devilsec.session" 2>/dev/null || echo "?")
cat <<EOF

  ╔════════════════════════════════════════════════════════╗
  ║                                                        ║
  ║   DEVILSEC  v${V}
  ║   "Power, given by others, is never truly yours."      ║
  ║                                                        ║
  ║   installed:   $I
  ║   home:        /opt/devilsec
  ║                                                        ║
  ╚════════════════════════════════════════════════════════╝

  Configs:
    ~/.config/{bspwm,sxhkd,polybar,picom,kitty,rofi,dunst,fastfetch}/

  Arsenal:
    /opt/devilsec/bin  (on \$PATH system-wide)
    /opt/devilsec/share/pivoting/ligolo/   (Win/Linux agents staged)

  Run 'devilsec-arsenal' for full catalogue.
  Run 'show-help-panel' for all keybindings.

EOF
