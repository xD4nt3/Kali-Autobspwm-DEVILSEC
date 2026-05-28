#!/usr/bin/env bash
# styx · wallpaper v2 — adds "pick any from disk"
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

current=""
[[ -f "$STATE" ]] && current=$(cat "$STATE")

apply() {
    set-wallpaper "$1"
}

cat <<EOF

  ${B}styx · wallpaper${R}     ${D}${COUNT} DEVILSEC wallpapers available${R}
  ${D}current: ${current:-none}${R}

    ${VIO}1${R}.  next               (DEVILSEC pack)
    ${VIO}2${R}.  previous           (DEVILSEC pack)
    ${VIO}3${R}.  random             (DEVILSEC pack)
    ${VIO}4${R}.  pick from DEVILSEC pack       (rofi)
    ${VIO}5${R}.  pick from disk     (any image in ~)
    ${VIO}6${R}.  manual path        (type a full path)
    ${VIO}0${R}.  back

EOF
printf "  ${CRIM}†${R}  ▸ "
read -r c
case "${c:-0}" in
    1|2)
        if (( COUNT == 0 )); then echo "no devilsec wallpapers"; exit 0; fi
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
        if (( COUNT == 0 )); then echo "no devilsec wallpapers"; exit 0; fi
        sel="${WALLS[$RANDOM % COUNT]}"
        apply "$sel"
        echo "  → $(basename "$sel")"
        ;;
    4)
        set-wallpaper
        ;;
    5)
        set-wallpaper --any
        ;;
    6)
        printf "  full path ▸ "; read -r p
        [[ -n "$p" ]] && set-wallpaper "$p"
        ;;
    0|"") ;;
    *) echo "  invalid" ;;
esac
