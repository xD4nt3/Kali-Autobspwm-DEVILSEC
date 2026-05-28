#!/usr/bin/env bash
set -uo pipefail
cur=""
if command -v brightnessctl &>/dev/null; then
    max=$(brightnessctl m 2>/dev/null)
    g=$(brightnessctl g 2>/dev/null)
    [[ -n "$max" && "$max" != "0" ]] && cur=$(( g * 100 / max ))
fi
cat <<EOF

  styx · brightness     current: ${cur:-unknown}%

EOF
printf "  new value [1-100] ▸ "; read -r v
[[ "$v" =~ ^[0-9]+$ ]] && (( v >= 1 && v <= 100 )) || { echo invalid; exit 1; }
if command -v brightnessctl &>/dev/null && brightnessctl m &>/dev/null; then
    brightnessctl set "${v}%" >/dev/null
    echo "  → ${v}% (hardware)"
else
    out=$(xrandr | awk '/ connected/{print $1; exit}')
    if [[ -n "$out" ]]; then
        f=$(awk "BEGIN {printf \"%.2f\", $v/100}")
        xrandr --output "$out" --brightness "$f"
        echo "  → ${v}% (software)"
    fi
fi
