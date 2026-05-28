#!/usr/bin/env bash
set -uo pipefail
cat <<EOF

  styx · tools

    1.  list arsenal (all categories)
    2.  show category    (pivoting|active-directory|impacket|relay-coercion|recon-web|privesc-postexp)
    3.  search arsenal
    4.  Pivoting » start ligolo proxy
    5.  Pivoting » list staged agents
    6.  Pivoting » serve agents on :8000
    7.  BloodHound CE status
    8.  PEASS-ng serve :8080
    9.  wlfind (search wordlists)
    0.  back

EOF
printf "  ▸ "; read -r c
case "${c:-0}" in
    1) devilsec-arsenal | less -R ;;
    2) printf "  cat ▸ "; read -r cat; [[ -n "$cat" ]] && devilsec-arsenal "$cat" | less -R ;;
    3) printf "  kw ▸ "; read -r kw; [[ -n "$kw" ]] && devilsec-arsenal --search "$kw" ;;
    4) printf "  port [11601] ▸ "; read -r p; ligolo proxy "${p:-11601}" ;;
    5) ligolo stage ;;
    6) ligolo serve ;;
    7) command -v bloodhound-ce &>/dev/null && bloodhound-ce status ;;
    8) command -v peas-serve &>/dev/null && peas-serve 8080 ;;
    9) printf "  kw ▸ "; read -r kw; [[ -n "$kw" ]] && wlfind "$kw" ;;
    0|"") ;;
esac
