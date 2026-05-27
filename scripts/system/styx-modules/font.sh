#!/usr/bin/env bash
set -uo pipefail
K="$HOME/.config/kitty/kitty.conf"
P="$HOME/.config/polybar/config.ini"
ks=$(grep -E "^font_size" "$K" 2>/dev/null | awk '{print $2}')
ps=$(grep -oP 'JetBrainsMono Nerd Font:size=\K[0-9]+' "$P" 2>/dev/null | head -1)

cat <<EOF

  styx · font size      kitty=${ks:-?}  polybar=${ps:-?}

    1.  kitty font size
    2.  polybar font size
    0.  back

EOF
printf "  ▸ "; read -r c
case "${c:-0}" in
    1)
        printf "  new ▸ "; read -r n
        [[ "$n" =~ ^[0-9]+$ ]] || exit 1
        sed -i -E "s/^font_size\s+.*/font_size $n/" "$K"
        pgrep -x kitty | xargs -r kill -SIGUSR1 2>/dev/null
        echo "  → kitty=$n"
        ;;
    2)
        printf "  new ▸ "; read -r n
        [[ "$n" =~ ^[0-9]+$ ]] || exit 1
        sed -i -E "s/(JetBrainsMono Nerd Font:size=)[0-9]+/\\1${n}/g" "$P"
        pkill -x polybar; sleep 0.2; "$HOME/.config/polybar/launch.sh" &>/dev/null & disown
        echo "  → polybar=$n"
        ;;
    0|"") ;;
esac
