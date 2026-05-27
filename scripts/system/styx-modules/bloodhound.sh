#!/usr/bin/env bash
# styx · bloodhound
set -uo pipefail

if ! command -v bloodhound-ce &>/dev/null; then
    cat <<EOF

  bloodhound-ce is not installed.

  To install it now, run:
    bash /opt/devilsec/share/styx/install-bh.sh

  Or rerun the DEVILSEC installer and accept BloodHound when asked.
EOF
    exit 1
fi

cat <<EOF

  styx · bloodhound CE

    1.  status       (ps)
    2.  start        (up -d)
    3.  stop         (down)
    4.  restart
    5.  tail logs    (Ctrl+C to exit)
    6.  update       (pull + restart)
    7.  destroy data (nuke)
    0.  back

EOF

printf '  ▸ '
read -r c
case "$c" in
    1) bloodhound-ce status ;;
    2) bloodhound-ce up ;;
    3) bloodhound-ce down ;;
    4) bloodhound-ce restart ;;
    5) bloodhound-ce logs ;;
    6) bloodhound-ce update ;;
    7) bloodhound-ce nuke ;;
    0|"") ;;
    *) echo "  invalid" ;;
esac
