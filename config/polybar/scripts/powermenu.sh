#!/usr/bin/env bash
# polybar/scripts/powermenu.sh — DEVILSEC power menu via rofi
set -uo pipefail

THEME="$HOME/.config/rofi/themes/devilsec-power.rasi"
[[ ! -f "$THEME" ]] && THEME="$HOME/.config/rofi/themes/devilsec.rasi"

opts=(
    "󰌾  Lock"
    "󰗽  Logout"
    "󰜉  Reboot"
    "󰐥  Shutdown"
    "󰕇  Suspend"
)

choice=$(printf '%s\n' "${opts[@]}" | rofi -dmenu -i -p "" -theme "$THEME" 2>/dev/null)

case "$choice" in
    *Lock*)      betterlockscreen -l || i3lock -c 0a0810 ;;
    *Logout*)    bspc quit ;;
    *Reboot*)    systemctl reboot ;;
    *Shutdown*)  systemctl poweroff ;;
    *Suspend*)   betterlockscreen -l & systemctl suspend ;;
esac
