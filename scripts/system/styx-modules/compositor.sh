#!/usr/bin/env bash
set -uo pipefail
PRES="$HOME/.config/picom/presets"
CFG="$HOME/.config/picom/picom.conf"

cat <<EOF

  styx · compositor

    1.  safe        no blur, transparency only          (default · VBox-safe)
    2.  blur        kawase blur (needs GLX + GPU)
    3.  none        disable picom entirely (instant fix when broken)
    0.  back

EOF
printf "  ▸ "; read -r c
case "${c:-0}" in
    1)
        if [[ -f "$PRES/safe.conf" ]] && command -v picom-guard &>/dev/null; then
            picom-guard apply "$PRES/safe.conf"
            echo "  → safe"
        else
            echo "preset missing or picom-guard not installed"
        fi
        ;;
    2)
        if [[ -f "$PRES/blur.conf" ]] && command -v picom-guard &>/dev/null; then
            picom-guard apply "$PRES/blur.conf" || \
                echo "  rolled back — blur preset incompatible with this system"
        fi
        ;;
    3)
        pkill -x picom; echo "  → picom stopped"
        ;;
    0|"") ;;
    *) echo invalid ;;
esac
