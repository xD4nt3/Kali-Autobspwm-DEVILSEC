#!/usr/bin/env bash
# polybar/scripts/updates.sh — show pending apt updates with elegant glyph
# Output is wrapped in colour codes that polybar parses as %{F#…}…%{F-}.

count=$(apt list --upgradable 2>/dev/null | tail -n +2 | wc -l)
if (( count == 0 )); then
    printf "%%{F#807a90}󰂪%%{F-} up to date"
elif (( count < 10 )); then
    printf "%%{F#D4AF37}󰚰%%{F-} %d update" "$count"
else
    printf "%%{F#DC2641}󰚰%%{F-} %d updates" "$count"
fi
