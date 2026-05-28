#!/usr/bin/env bash
set -uo pipefail
CFG="$HOME/.config/polybar/config.ini"
H=$(grep -E "^height\s" "$CFG" 2>/dev/null | head -1 | awk '{print $3}')
H="${H:-30}"

cat <<EOF

  styx · polybar     current height=${H}px

    1.  height ↑↓
    2.  variant (default / minimal / spectral)
    3.  restart polybar
    0.  back

EOF
printf "  ▸ "; read -r c
restart(){ pkill -x polybar; sleep 0.3; "$HOME/.config/polybar/launch.sh" &>/dev/null & disown; }
case "${c:-0}" in
    1)
        printf "  new height [20-60] ▸ "; read -r v
        [[ "$v" =~ ^[0-9]+$ ]] && (( v >= 20 && v <= 60 )) || { echo invalid; exit 1; }
        sed -i -E "s/^(height\s*=\s*).*/\\1${v}/" "$CFG"
        restart
        echo "  → height=${v}"
        ;;
    2)
        printf "  variant [default|minimal|spectral] ▸ "; read -r v
        TF="$HOME/.config/polybar/themes/${v}.ini"
        if [[ -f "$TF" ]]; then
            cp "$TF" "$CFG"; restart; echo "  → $v"
        else
            echo "no such variant"
        fi
        ;;
    3) restart; echo "  → restarted" ;;
    0|"") ;;
    *) echo invalid ;;
esac
