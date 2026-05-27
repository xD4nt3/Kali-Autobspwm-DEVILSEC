#!/usr/bin/env bash
# Phase 60 · SecLists & curated wordlists
set -uo pipefail
source "$DEVILSEC_ROOT/core/forge.sh"

WL_ROOT=/opt/devilsec/wordlists
sudo mkdir -p "$WL_ROOT"
sudo chown -R "$USER:$USER" "$WL_ROOT"

# ─── SecLists ─────────────────────────────────────────────────────────────────
SECLISTS_DIR="$WL_ROOT/SecLists"
if [[ ! -d "$SECLISTS_DIR" ]]; then
    forge::step "Cloning SecLists (this may take a few minutes — ~600 MB)"
    git clone --depth=1 https://github.com/danielmiessler/SecLists.git "$SECLISTS_DIR" 2>&1 \
        | tail -3
    forge::ok "SecLists in place"
else
    forge::step "Refreshing SecLists"
    (cd "$SECLISTS_DIR" && git pull --quiet) || true
fi

# ─── PayloadsAllTheThings ─────────────────────────────────────────────────────
PAT_DIR="$WL_ROOT/PayloadsAllTheThings"
if [[ ! -d "$PAT_DIR" ]]; then
    forge::step "Cloning PayloadsAllTheThings"
    git clone --depth=1 https://github.com/swisskyrepo/PayloadsAllTheThings.git "$PAT_DIR" 2>&1 \
        | tail -3
else
    (cd "$PAT_DIR" && git pull --quiet) || true
fi

# ─── rockyou (kali's gzipped one) ─────────────────────────────────────────────
forge::step "Ensuring rockyou.txt is extracted"
ROCKYOU_GZ=/usr/share/wordlists/rockyou.txt.gz
ROCKYOU=/usr/share/wordlists/rockyou.txt
if [[ -f "$ROCKYOU_GZ" && ! -f "$ROCKYOU" ]]; then
    sudo gunzip -k "$ROCKYOU_GZ" && forge::ok "rockyou.txt extracted"
elif [[ -f "$ROCKYOU" ]]; then
    forge::info "rockyou.txt already extracted"
fi

# Make sure rockyou is reachable from our wordlists dir as a symlink
[[ -f "$ROCKYOU" ]] && ln -sf "$ROCKYOU" "$WL_ROOT/rockyou.txt"

# ─── Quick search helper: 'wlfind' ────────────────────────────────────────────
sudo tee /opt/devilsec/bin/wlfind >/dev/null <<'EOF'
#!/usr/bin/env bash
# DEVILSEC · fuzzy search across all wordlists
# Usage: wlfind <keyword> [-l]
KEY="${1:?usage: wlfind <keyword> [-l]}"
shift || true
ROOT=/opt/devilsec/wordlists
if [[ "${1:-}" == "-l" ]]; then
    find "$ROOT" -type f -iname "*${KEY}*" | head -50
else
    find "$ROOT" -type f -iname "*${KEY}*" | fzf --preview 'head -50 {}'
fi
EOF
sudo chmod +x /opt/devilsec/bin/wlfind

forge::ok "Wordlists phase complete"
forge::hint "Search wordlists with: wlfind <keyword>"
