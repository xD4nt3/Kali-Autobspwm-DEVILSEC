#!/usr/bin/env bash
set -uo pipefail
SCOPE="$HOME/.config/devilsec/scope.list"
mkdir -p "$(dirname "$SCOPE")"
touch "$SCOPE"

cat <<EOF

  styx · scope manager

    Current scope:
$(awk '{printf "      • %s\n", $0}' "$SCOPE" 2>/dev/null || echo "      (empty)")

    1.  add asset
    2.  remove asset
    3.  set target IP (the one polybar copies via Super+Shift+F3)
    4.  clear scope
    0.  back

EOF
printf "  ▸ "; read -r c
case "${c:-0}" in
    1) printf "  asset ▸ "; read -r a; [[ -n "$a" ]] && echo "$a" >> "$SCOPE" && echo "added" ;;
    2) printf "  asset ▸ "; read -r a; [[ -n "$a" ]] && sed -i "/^$(printf '%s' "$a" | sed 's|/|\\/|g')\$/d" "$SCOPE" && echo "removed" ;;
    3) printf "  target IP ▸ "; read -r ip; [[ -n "$ip" ]] && echo "$ip" > "$HOME/.config/devilsec/target-ip" && echo "  target=$ip" ;;
    4) : > "$SCOPE"; echo cleared ;;
    0|"") ;;
esac
