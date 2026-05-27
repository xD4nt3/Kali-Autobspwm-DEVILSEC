#!/usr/bin/env bash
# polybar launcher — DEVILSEC

# Terminate any existing polybar instances cleanly
pkill -x polybar
while pgrep -x polybar >/dev/null; do sleep 0.1; done

# Launch one instance of the "devilsec" bar per connected monitor
if type "xrandr" >/dev/null 2>&1; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR="$m" polybar --reload devilsec &>/dev/null &
    done
else
    polybar --reload devilsec &>/dev/null &
fi
