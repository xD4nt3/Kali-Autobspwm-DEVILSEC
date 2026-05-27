#!/usr/bin/env bash
# styx · wallpaper
set -uo pipefail

if [[ -t 1 ]]; then
    R=$'\033[0m'; B=$'\033[1m'; D=$'\033[2m'
    CRIM=$'\033[38;2;220;38;65m'; VIO=$'\033[38;2;138;43;226m'
fi

WALL_DIR="$HOME/Pictures/devilsec-wallpapers"
LINK="$HOME/.config/devilsec-wallpaper"
STATE="$HOME/.config/devilsec/wallpaper.state"
mkdir -p "$(dirname "$STATE")"

mapfile -t WALLS < <(find "$WALL_DIR" -type f \
    \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) 2>/dev/null \
    | sort)
COUNT=${#WALLS[@]}

if (( COUNT == 0 )); then
    echo "  no wallpapers in $WALL_DIR"
    exit 0
fi

apply() {
    local w="$1"
    feh --no-fehbg --bg-fill "$w"
    ln -sf "$w" "$LINK"
    echo "$w" > "$STATE"
}

current=""
[[ -f "$STATE" ]] && current=$(cat "$STATE")

cat <<EOF

  ${B}styx · wallpaper${R}     ${D}${COUNT} wallpapers available${R}
  ${D}current: ${current:-none}${R}

    ${VIO}1${R}.  next
    ${VIO}2${R}.  previous
    ${VIO}3${R}.  random
    ${VIO}4${R}.  pick from list (rofi)
    ${VIO}0${R}.  back

EOF
printf "  ${CRIM}†${R}  ▸ "
read -r c
case "${c:-0}" in
    1|2)
        idx=0
        for i in "${!WALLS[@]}"; do
            [[ "${WALLS[$i]}" == "$current" ]] && idx=$i && break
        done
        if [[ "$c" == "1" ]]; then
            idx=$(( (idx + 1) % COUNT ))
        else
            idx=$(( (idx - 1 + COUNT) % COUNT ))
        fi
        apply "${WALLS[$idx]}"
        echo "  → $(basename "${WALLS[$idx]}")"
        ;;
    3)
        sel="${WALLS[$RANDOM % COUNT]}"
        apply "$sel"
        echo "  → $(basename "$sel")"
        ;;
    4)
        if command -v rofi &>/dev/null; then
            picked=$(printf '%s\n' "${WALLS[@]}" | xargs -n1 basename | \
                rofi -dmenu -i -p "wallpaper" \
                -theme "$HOME/.config/rofi/themes/devilsec.rasi" 2>/dev/null)
            if [[ -n "$picked" ]]; then
                for w in "${WALLS[@]}"; do
                    [[ "$(basename "$w")" == "$picked" ]] && { apply "$w"; echo "  → $picked"; break; }
                done
            fi
        fi
        ;;
    0|"") ;;
    *) echo "  invalid" ;;
esac
