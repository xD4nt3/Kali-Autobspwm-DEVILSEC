#!/usr/bin/env bash
# Phase 50 · BloodHound CE (opt-in, containerised)
set -uo pipefail
source "$DEVILSEC_ROOT/core/forge.sh"

forge::info "BloodHound CE is heavy (Docker + Neo4j + Postgres + app)."
forge::info "It needs ~8 GiB RAM at runtime."
forge::ask "Install BloodHound CE now? [y/N]" bh_ans

if ! [[ "${bh_ans,,}" =~ ^y(es)?$ ]]; then
    forge::info "Skipping BloodHound CE. You can install it later with:"
    forge::hint "    bash $DEVILSEC_ROOT/core/phases/50-bloodhound.sh"
    exit 0
fi

# ─── Docker engine ────────────────────────────────────────────────────────────
if ! command -v docker &>/dev/null; then
    forge::step "Installing docker.io and docker-compose-v2 from Kali repos"
    forge::apt_install docker.io docker-compose-v2
fi

forge::step "Enabling and starting docker"
sudo systemctl enable --now docker

# Allow current user to run docker without sudo
if ! groups "$USER" | grep -q docker; then
    sudo usermod -aG docker "$USER"
    forge::warn "Added ${USER} to the 'docker' group — you must log out & back in (or reboot) for it to take effect."
fi

# ─── BloodHound CE deploy ─────────────────────────────────────────────────────
BHCE_DIR=/opt/devilsec/bloodhound-ce
sudo mkdir -p "$BHCE_DIR"
sudo chown "$USER:$USER" "$BHCE_DIR"

forge::step "Fetching latest BloodHound CE docker-compose"
curl -fsSL https://ghst.ly/getbhce -o "$BHCE_DIR/docker-compose.yml"

# ─── Convenience launcher ─────────────────────────────────────────────────────
sudo tee /opt/devilsec/bin/bloodhound-ce >/dev/null <<'EOF'
#!/usr/bin/env bash
# DEVILSEC · BloodHound CE controller
set -e
BHCE_DIR=/opt/devilsec/bloodhound-ce
cd "$BHCE_DIR"

ACTION="${1:-status}"
DC="docker compose"
$DC version &>/dev/null || DC="docker-compose"

case "$ACTION" in
    up|start)
        echo "[*] Starting BloodHound CE…"
        $DC up -d
        echo
        echo "[*] Waiting for initial password (≈10 s)…"
        sleep 8
        # First-start password is printed by the bloodhound container
        for c in $($DC ps -q bloodhound 2>/dev/null); do
            docker logs "$c" 2>&1 | grep -m1 -E "Initial Password Set To:" || true
        done
        echo
        echo "[*] UI ready at  http://localhost:8080/ui/login"
        echo "    user: admin"
        ;;
    down|stop)
        echo "[*] Stopping BloodHound CE…"
        $DC down
        ;;
    restart)
        $DC restart
        ;;
    logs)
        $DC logs -f
        ;;
    update)
        $DC pull && $DC up -d
        ;;
    nuke)
        read -p "This destroys all BloodHound data. Continue? [y/N] " a
        [[ "${a,,}" == y* ]] && $DC down -v && echo "[*] Volumes destroyed."
        ;;
    status|*)
        $DC ps
        ;;
esac
EOF
sudo chmod +x /opt/devilsec/bin/bloodhound-ce

forge::ok "BloodHound CE configured (start it with: bloodhound-ce up)"
