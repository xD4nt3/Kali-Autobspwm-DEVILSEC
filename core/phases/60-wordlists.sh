#!/usr/bin/env bash
# Phase 60 · SecLists & curated wordlists
set -uo pipefail
source "$DEVILSEC_ROOT/core/forge.sh"

WL_ROOT=/opt/devilsec/wordlists
STANDARD_PATH="/usr/share/seclists"
sudo mkdir -p "$WL_ROOT"

# ─── SecLists at the standard Kali location ─────────────────────────────────
if [[ -d "$STANDARD_PATH" ]] && [[ "$(ls -A "$STANDARD_PATH" 2>/dev/null | wc -l)" -gt 5 ]]; then
    forge::ok "SecLists already present at $STANDARD_PATH"
elif apt-cache show seclists &>/dev/null; then
    forge::step "Installing SecLists via apt (~600 MB, takes a few minutes)"
    if sudo DEBIAN_FRONTEND=noninteractive apt-get install -y seclists; then
        forge::ok "SecLists installed at $STANDARD_PATH via apt"
    else
        forge::warn "apt install failed — falling back to git clone"
        sudo mkdir -p "$STANDARD_PATH"
        sudo chown "$USER":"$USER" "$STANDARD_PATH"
        git clone --depth=1 https://github.com/danielmiessler/SecLists.git "$STANDARD_PATH" \
            && forge::ok "SecLists cloned to $STANDARD_PATH" \
            || forge::warn "SecLists clone failed — skipping (you can run devilsec-repair later)"
    fi
else
    forge::step "Cloning SecLists into $STANDARD_PATH (~600 MB, takes a few minutes)"
    sudo mkdir -p "$STANDARD_PATH"
    sudo chown "$USER":"$USER" "$STANDARD_PATH"
    git clone --depth=1 https://github.com/danielmiessler/SecLists.git "$STANDARD_PATH" \
        && forge::ok "SecLists in place" \
        || forge::warn "SecLists clone failed — skipping (you can run devilsec-repair later)"
fi

# Symlink in /opt/devilsec/wordlists for compatibility with old paths
if [[ -d "$STANDARD_PATH" ]] && [[ ! -e "$WL_ROOT/SecLists" ]]; then
    sudo ln -sf "$STANDARD_PATH" "$WL_ROOT/SecLists"
    forge::ok "Symlink: $WL_ROOT/SecLists → $STANDARD_PATH"
fi

# ─── Curated extras (rockyou, dirb common, etc.) ────────────────────────────
forge::step "Installing curated wordlists"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    wordlists dirb dirbuster 2>/dev/null || true

# Ensure rockyou is unzipped (Kali ships it gzipped at /usr/share/wordlists/rockyou.txt.gz)
if [[ -f /usr/share/wordlists/rockyou.txt.gz ]] && [[ ! -f /usr/share/wordlists/rockyou.txt ]]; then
    forge::step "Decompressing rockyou.txt"
    sudo gunzip -k /usr/share/wordlists/rockyou.txt.gz 2>/dev/null && \
        forge::ok "rockyou.txt ready"
fi

# ─── wlfind helper to fuzzy-search wordlists ────────────────────────────────
forge::step "Installing wlfind helper"
sudo tee /opt/devilsec/bin/wlfind >/dev/null <<'WL_EOF'
#!/usr/bin/env bash
# wlfind <keyword> — fuzzy search the wordlists tree
set -uo pipefail
kw="${1:-}"
if [[ -z "$kw" ]]; then
    echo "usage: wlfind <keyword>" >&2
    exit 1
fi
for d in /usr/share/seclists /usr/share/wordlists /opt/devilsec/wordlists; do
    [[ -d "$d" ]] && find "$d" -iname "*${kw}*" 2>/dev/null
done | sort -u
WL_EOF
sudo chmod +x /opt/devilsec/bin/wlfind
forge::ok "wlfind installed"

forge::ok "Phase 60 complete"
