#!/usr/bin/env bash
# styx · background opacity v1.1.1
# Adjusts BACKGROUND transparency only — text/cursor stay 100% solid.
set -uo pipefail

if [[ -t 1 ]]; then
    R=$'\033[0m'; B=$'\033[1m'; D=$'\033[2m'
    CRIM=$'\033[38;2;220;38;65m'; VIO=$'\033[38;2;138;43;226m'
else
    R=""; B=""; D=""; CRIM=""; VIO=""
fi

STATE="$HOME/.config/devilsec/opacity.state"
F=80
[[ -f "$STATE" ]] && source "$STATE" 2>/dev/null || true
F="${FOCUSED:-$F}"

cat <<EOF

  ${B}styx · background opacity${R}     ${D}current: ${F}%${R}

    ${D}Only the BACKGROUND becomes transparent.${R}
    ${D}Text, cursor and selection stay 100% solid (no more ghost text).${R}

    ${VIO}1${R}.  more transparent     (${F}% → -5%)
    ${VIO}2${R}.  more opaque          (${F}% → +5%)
    ${VIO}3${R}.  preset · whisper      45%
    ${VIO}4${R}.  preset · glass        70%
    ${VIO}5${R}.  preset · solid        90%
    ${VIO}6${R}.  preset · opaque       100%  (no transparency)
    ${VIO}7${R}.  custom value          30-100%
    ${VIO}0${R}.  back

EOF
printf "  ${CRIM}†${R}  ▸ "
read -r c
case "${c:-0}" in
    1)
        new=$(( F - 5 ))
        (( new < 30 )) && new=30
        devilsec-opacity "$new"
        ;;
    2)
        new=$(( F + 5 ))
        (( new > 100 )) && new=100
        devilsec-opacity "$new"
        ;;
    3) devilsec-opacity 45 ;;
    4) devilsec-opacity 70 ;;
    5) devilsec-opacity 90 ;;
    6) devilsec-opacity 100 ;;
    7)
        printf "  background opacity%% [30-100] ▸ "; read -r nv
        devilsec-opacity "$nv"
        ;;
    0|"") ;;
    *) echo "  invalid" ;;
esac
