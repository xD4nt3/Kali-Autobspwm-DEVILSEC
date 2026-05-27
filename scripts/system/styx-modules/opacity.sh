#!/usr/bin/env bash
# styx · opacity v1.1.0 final
# All presets stay within the 60-100% safe range (xrender + VBox limit).
set -uo pipefail

if [[ -t 1 ]]; then
    R=$'\033[0m'; B=$'\033[1m'; D=$'\033[2m'
    CRIM=$'\033[38;2;220;38;65m'; VIO=$'\033[38;2;138;43;226m'
else
    R=""; B=""; D=""; CRIM=""; VIO=""
fi

STATE="$HOME/.config/devilsec/opacity.state"
F=85; U=75
[[ -f "$STATE" ]] && source "$STATE" 2>/dev/null || true
F="${FOCUSED:-$F}"; U="${UNFOCUSED:-$U}"

cat <<EOF

  ${B}styx · window opacity${R}     ${D}current: focused=${F}%  unfocused=${U}%${R}

    Adjusts client-side opacity via xprop. Values below 60% render as
    BLACK in VirtualBox without 3D acceleration, so this menu won't
    let you go lower.

    ${VIO}1${R}.  more transparent     (focused -5, unfocused -5; min 60%)
    ${VIO}2${R}.  more opaque          (focused +5, unfocused +5)
    ${VIO}3${R}.  preset · whisper      65% / 60%
    ${VIO}4${R}.  preset · glass        80% / 70%
    ${VIO}5${R}.  preset · solid        92% / 88%
    ${VIO}6${R}.  custom values         60-100%
    ${VIO}7${R}.  reset client opacity  remove opacity property
    ${VIO}0${R}.  back

EOF
printf "  ${CRIM}†${R}  ▸ "
read -r c
case "${c:-0}" in
    1)
        new_f=$(( F - 5 )); new_u=$(( U - 5 ))
        (( new_f < 60 )) && new_f=60
        (( new_u < 60 )) && new_u=60
        devilsec-opacity "$new_f" "$new_u"
        ;;
    2)
        new_f=$(( F + 5 )); new_u=$(( U + 5 ))
        (( new_f > 100 )) && new_f=100
        (( new_u > 100 )) && new_u=100
        devilsec-opacity "$new_f" "$new_u"
        ;;
    3) devilsec-opacity 65 60 ;;
    4) devilsec-opacity 80 70 ;;
    5) devilsec-opacity 92 88 ;;
    6)
        printf "  focused%% [60-100] ▸ "; read -r nf
        printf "  unfocused%% [60-100] ▸ "; read -r nu
        devilsec-opacity "$nf" "$nu"
        ;;
    7) devilsec-opacity reset ;;
    0|"") ;;
    *) echo "  invalid" ;;
esac
