#!/usr/bin/env bash
set -uo pipefail
THEMES="$HOME/.config/devilsec/themes"
mkdir -p "$THEMES"
ACTIVE="$HOME/.config/devilsec/active-theme"
cur=$(cat "$ACTIVE" 2>/dev/null || echo limbo)

cat <<EOF

  styx · colour theme        active: $cur

    1.  Limbo        balanced violet + crimson
    2.  Inferno      warmer · ember and blood
    3.  Purgatory    cooler · deep purple
    0.  back

EOF
printf "  ▸ "; read -r c
apply(){ echo "$1" > "$ACTIVE"; pkill -USR1 -x polybar 2>/dev/null; echo "  → $1"; }
case "${c:-0}" in
    1) apply limbo ;;
    2) apply inferno ;;
    3) apply purgatory ;;
    0|"") ;;
    *) echo "invalid" ;;
esac
