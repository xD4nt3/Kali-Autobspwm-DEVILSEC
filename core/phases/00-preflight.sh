#!/usr/bin/env bash
# Phase 00 · Preflight · system checks and full update
set -uo pipefail
source "$DEVILSEC_ROOT/core/forge.sh"

forge::step "Verifying sudo access (you may be asked for your password)"
sudo -v || { forge::err "sudo required"; exit 1; }

# keep sudo alive in background
( while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done ) 2>/dev/null &
SUDO_KEEPALIVE_PID=$!
trap '[[ -n "${SUDO_KEEPALIVE_PID:-}" ]] && kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true' EXIT

forge::step "Checking internet connectivity"
if ! curl -fsS -m 5 -o /dev/null https://kali.org; then
    forge::err "No internet access. DEVILSEC requires network during summoning."
    exit 1
fi
forge::ok "Connection alive"

forge::step "Disk space check (need ≥ 20 GB free in /)"
avail=$(df --output=avail / | tail -1)
need=$((20 * 1024 * 1024))
if (( avail < need )); then
    forge::warn "Only $(( avail / 1024 / 1024 )) GiB free on /. BloodHound CE and SecLists may not fit."
fi

forge::step "Refreshing apt cache"
sudo apt-get update -qq

forge::step "Upgrading system packages (this can take a while)"
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq upgrade

forge::step "Cleaning up"
sudo apt-get -y -qq autoremove
sudo apt-get -y -qq clean

forge::ok "Preflight complete"
