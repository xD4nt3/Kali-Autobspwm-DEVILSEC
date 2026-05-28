#!/usr/bin/env bash
set -uo pipefail
cat <<EOF

  styx · gamma & temperature

    1.  day        6500K
    2.  dusk       4500K
    3.  night      3200K
    4.  custom
    5.  reset
    0.  back

EOF
printf "  ▸ "; read -r c
ap(){ command -v redshift &>/dev/null && pkill -x redshift 2>/dev/null; redshift -O "$1" &>/dev/null; echo "  → ${1}K"; }
case "${c:-0}" in
    1) ap 6500 ;;
    2) ap 4500 ;;
    3) ap 3200 ;;
    4) printf "  kelvin [1000-25000] ▸ "; read -r k; ap "$k" ;;
    5) redshift -x &>/dev/null; echo "  → reset" ;;
    0|"") ;;
    *) echo invalid ;;
esac
