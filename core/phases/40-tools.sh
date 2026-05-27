#!/usr/bin/env bash
# Phase 40 · Offensive arsenal
# All tools end up callable from anywhere via /opt/devilsec/bin.
set -uo pipefail
source "$DEVILSEC_ROOT/core/forge.sh"

mkdir -p /opt/devilsec/tools /opt/devilsec/bin

# ─── pipx baseline ────────────────────────────────────────────────────────────
forge::step "Ensuring pipx is ready"
forge::apt_install pipx
pipx ensurepath >/dev/null 2>&1 || true
# Make pipx-installed bins linkable from /opt/devilsec/bin
PIPX_BIN="$HOME/.local/bin"
mkdir -p "$PIPX_BIN"

# ─── 1. impacket (latest from upstream Fortra) ────────────────────────────────
forge::step "Installing impacket (latest from upstream)"
# We use --force to make pipx use upstream HEAD; many Kali users want the
# bleeding edge (gMSA, ESC*, etc.).
pipx install --force "git+https://github.com/fortra/impacket.git" 2>&1 \
    | grep -E '(installed|apps|These)' | head -5 || true

# Link the common impacket binaries into /opt/devilsec/bin
for tool in psexec.py smbexec.py wmiexec.py atexec.py dcomexec.py \
            secretsdump.py GetUserSPNs.py GetNPUsers.py getTGT.py \
            getST.py ticketer.py raiseChild.py addcomputer.py \
            ntlmrelayx.py mssqlclient.py rpcdump.py samrdump.py \
            lookupsid.py reg.py services.py smbserver.py smbclient.py \
            findDelegation.py describeTicket.py karmaSMB.py; do
    [[ -x "$PIPX_BIN/$tool" ]] && forge::link_tool "$PIPX_BIN/$tool"
done

# ─── 2. NetExec (the spiritual successor to crackmapexec) ─────────────────────
forge::step "Installing NetExec (nxc)"
pipx install --force --pip-args="--no-deps" "git+https://github.com/Pennyw0rth/NetExec" 2>&1 \
    | grep -E '(installed|apps|These)' | head -5 || true
# Inject deps separately so we don't fight bloodhound's loose pins
pipx inject netexec \
    "impacket @ git+https://github.com/Pennyw0rth/impacket.git" \
    aardwolf asyauth asyncio dnspython lsassy dploot pylnk3 \
    pypsrp pywerview wmi neo4j bloodhound \
    2>/dev/null || true
for b in nxc netexec nxcdb; do
    [[ -x "$PIPX_BIN/$b" ]] && forge::link_tool "$PIPX_BIN/$b"
done

# ─── 3. bloodyAD ──────────────────────────────────────────────────────────────
forge::step "Installing bloodyAD"
pipx install --force "git+https://github.com/CravateRouge/bloodyAD" 2>&1 \
    | grep -E '(installed|apps)' | head -3 || true
[[ -x "$PIPX_BIN/bloodyAD" ]] && forge::link_tool "$PIPX_BIN/bloodyAD"

# ─── 4. Certipy (ADCS abuse) ──────────────────────────────────────────────────
forge::step "Installing Certipy-AD"
pipx install --force "git+https://github.com/ly4k/Certipy" 2>&1 \
    | grep -E '(installed|apps)' | head -3 || true
[[ -x "$PIPX_BIN/certipy" ]] && forge::link_tool "$PIPX_BIN/certipy"
[[ -x "$PIPX_BIN/certipy-ad" ]] && forge::link_tool "$PIPX_BIN/certipy-ad" certipy-ad

# ─── 5. Coercer (printerbug / petitpotam family) ──────────────────────────────
forge::step "Installing Coercer"
pipx install --force "git+https://github.com/p0dalirius/Coercer" 2>&1 \
    | grep -E '(installed|apps)' | head -3 || true
[[ -x "$PIPX_BIN/Coercer" ]] && forge::link_tool "$PIPX_BIN/Coercer" coercer

# ─── 6. bloodhound-python (collector) ─────────────────────────────────────────
forge::step "Installing bloodhound-python (collector)"
pipx install --force bloodhound 2>&1 | grep -E '(installed|apps)' | head -3 || true
[[ -x "$PIPX_BIN/bloodhound-python" ]] && forge::link_tool "$PIPX_BIN/bloodhound-python"

# ─── 7. mitm6 ─────────────────────────────────────────────────────────────────
forge::step "Installing mitm6"
pipx install --force mitm6 2>&1 | grep -E '(installed|apps)' | head -3 || true
[[ -x "$PIPX_BIN/mitm6" ]] && forge::link_tool "$PIPX_BIN/mitm6"

# ─── 8. donpapi (DPAPI offline harvest) ───────────────────────────────────────
forge::step "Installing DonPAPI"
pipx install --force "git+https://github.com/login-securite/DonPAPI" 2>&1 \
    | grep -E '(installed|apps)' | head -3 || true
[[ -x "$PIPX_BIN/donpapi" ]] && forge::link_tool "$PIPX_BIN/donpapi"

# ─── 9. enum4linux-ng ─────────────────────────────────────────────────────────
forge::step "Installing enum4linux-ng"
pipx install --force enum4linux-ng 2>&1 | grep -E '(installed|apps)' | head -3 || true
[[ -x "$PIPX_BIN/enum4linux-ng" ]] && forge::link_tool "$PIPX_BIN/enum4linux-ng"

# ─── 10. updog (quick HTTP file server) ───────────────────────────────────────
forge::step "Installing updog"
pipx install --force updog 2>&1 | grep -E '(installed|apps)' | head -3 || true
[[ -x "$PIPX_BIN/updog" ]] && forge::link_tool "$PIPX_BIN/updog"

# ─── 11. kerbrute (Go binary) ─────────────────────────────────────────────────
forge::step "Installing kerbrute (binary)"
KB_VER=$(curl -fsSL https://api.github.com/repos/ropnop/kerbrute/releases/latest 2>/dev/null \
    | grep -oP '"tag_name":\s*"\K[^"]+' | head -1)
if [[ -n "${KB_VER:-}" ]]; then
    sudo curl -fsSL -o /opt/devilsec/tools/kerbrute \
        "https://github.com/ropnop/kerbrute/releases/download/${KB_VER}/kerbrute_linux_amd64"
    sudo chmod +x /opt/devilsec/tools/kerbrute
    forge::link_tool /opt/devilsec/tools/kerbrute kerbrute
    forge::ok "kerbrute ${KB_VER}"
else
    forge::warn "Could not fetch kerbrute release"
fi

# ─── 12. evil-winrm ───────────────────────────────────────────────────────────
forge::step "Installing evil-winrm"
if ! command -v evil-winrm &>/dev/null; then
    forge::apt_install ruby ruby-dev
    sudo gem install evil-winrm --no-document >/dev/null 2>&1 \
        && forge::ok "evil-winrm installed" \
        || forge::warn "evil-winrm install failed"
fi

# ─── 13. ligolo-ng (modern pivoting · proxy + cross-platform agents) ─────────
# Pivoting category. We deploy the proxy locally, and stage agents for every
# common victim arch under /opt/devilsec/share/pivoting/ligolo so the operator
# can `cp` them straight into a transfer without re-downloading.
forge::step "Installing ligolo-ng (proxy + Win/Linux agents)"

LIGOLO_STAGE=/opt/devilsec/share/pivoting/ligolo
sudo mkdir -p "$LIGOLO_STAGE"
sudo chown -R "$USER:$USER" "$LIGOLO_STAGE"

LN_TAG=$(curl -fsSL https://api.github.com/repos/nicocha30/ligolo-ng/releases/latest 2>/dev/null \
    | grep -oP '"tag_name":\s*"\K[^"]+' | head -1)

if [[ -n "${LN_TAG:-}" ]]; then
    LN_VER="${LN_TAG#v}"
    LN_BASE="https://github.com/nicocha30/ligolo-ng/releases/download/${LN_TAG}"
    tmp=$(mktemp -d)
    cd "$tmp"

    # Helper: download <url> <archive-name> <member-pattern> <final-destination>
    __fetch_ligolo() {
        local url="$1" archive="$2" member="$3" dest="$4"
        if curl -fsSL -o "$archive" "$url" 2>/dev/null; then
            if [[ "$archive" == *.zip ]]; then
                unzip -qo "$archive" >/dev/null 2>&1 || return 1
            else
                tar xzf "$archive" 2>/dev/null || return 1
            fi
            local extracted
            extracted=$(find . -maxdepth 2 -type f -name "$member" 2>/dev/null | head -1)
            [[ -n "$extracted" ]] || return 1
            sudo install -m 0755 "$extracted" "$dest"
            rm -f "$archive"
            # Clean the extracted file so the next loop iteration doesn't pick it up
            rm -f "$extracted"
            return 0
        fi
        return 1
    }

    # ─ Proxy (operator-side, always Linux amd64 for the local Kali) ───────────
    if __fetch_ligolo \
        "${LN_BASE}/ligolo-ng_proxy_${LN_VER}_linux_amd64.tar.gz" \
        "proxy.tar.gz" "proxy" \
        "/opt/devilsec/tools/ligolo-proxy"
    then
        forge::link_tool /opt/devilsec/tools/ligolo-proxy ligolo-proxy
        forge::ok "ligolo proxy ${LN_TAG}"
    else
        forge::warn "could not fetch ligolo proxy"
    fi

    # ─ Linux agents (amd64, arm64) ───────────────────────────────────────────
    for arch in amd64 arm64; do
        if __fetch_ligolo \
            "${LN_BASE}/ligolo-ng_agent_${LN_VER}_linux_${arch}.tar.gz" \
            "agent_linux_${arch}.tar.gz" "agent" \
            "${LIGOLO_STAGE}/ligolo-agent_linux_${arch}"
        then
            forge::ok "  · ligolo agent · linux/${arch}"
        else
            forge::warn "  · skipped agent · linux/${arch}"
        fi
    done

    # ─ Windows agents (amd64, arm64) ─────────────────────────────────────────
    for arch in amd64 arm64; do
        # Windows releases ship as .zip with agent.exe inside
        if __fetch_ligolo \
            "${LN_BASE}/ligolo-ng_agent_${LN_VER}_windows_${arch}.zip" \
            "agent_windows_${arch}.zip" "agent.exe" \
            "${LIGOLO_STAGE}/ligolo-agent_windows_${arch}.exe"
        then
            forge::ok "  · ligolo agent · windows/${arch}"
        else
            forge::warn "  · skipped agent · windows/${arch}"
        fi
    done

    cd / && rm -rf "$tmp"

    # Convenience launcher: `ligolo` — opens the staging dir, or starts proxy.
    sudo tee /opt/devilsec/bin/ligolo >/dev/null <<EOF
#!/usr/bin/env bash
# DEVILSEC · ligolo helper
# Usage:
#   ligolo            → show staged agents and proxy hint
#   ligolo proxy      → launch the proxy with a self-signed cert on :11601
#   ligolo proxy <p>  → launch the proxy on port <p>
#   ligolo stage      → list staged agent binaries (paths to copy)
#   ligolo serve      → start a quick HTTP server in the staging dir on :8000
set -e
STAGE=/opt/devilsec/share/pivoting/ligolo
case "\${1:-}" in
    proxy)
        port="\${2:-11601}"
        echo "[*] ligolo proxy listening on :\${port}  (selfcert)"
        exec ligolo-proxy -selfcert -laddr "0.0.0.0:\${port}"
        ;;
    stage|agents|list)
        echo "Staged ligolo agents in \${STAGE}:"
        printf "  %s\n" \$(ls -1 "\${STAGE}" 2>/dev/null)
        ;;
    serve)
        echo "[*] serving \${STAGE} on :8000  (Ctrl+C to stop)"
        cd "\${STAGE}" && exec python3 -m http.server 8000
        ;;
    *)
        cat <<H
ligolo · DEVILSEC pivoting helper

  ligolo proxy [port]   start the operator proxy   (default 11601)
  ligolo stage          list staged agents
  ligolo serve          serve agents on :8000

Staged agents:
H
        printf "    %s\n" \$(ls -1 "\${STAGE}" 2>/dev/null)
        ;;
esac
EOF
    sudo chmod +x /opt/devilsec/bin/ligolo

    # Categorise the binaries so devilsec-arsenal can group them under Pivoting
    sudo mkdir -p /opt/devilsec/share/categories
    sudo tee /opt/devilsec/share/categories/pivoting.list >/dev/null <<EOF
ligolo            ligolo-ng helper (proxy + staged agents)
ligolo-proxy      ligolo-ng operator-side proxy
chisel            jpillora/chisel (TCP/UDP over HTTP tunnel)
EOF

else
    forge::warn "Could not fetch ligolo-ng release metadata"
fi

# ─── 14. chisel (port forward) ────────────────────────────────────────────────
forge::step "Installing chisel"
CH_TAG=$(curl -fsSL https://api.github.com/repos/jpillora/chisel/releases/latest 2>/dev/null \
    | grep -oP '"tag_name":\s*"\K[^"]+' | head -1)
if [[ -n "${CH_TAG:-}" ]]; then
    CH_VER="${CH_TAG#v}"
    tmp=$(mktemp -d)
    cd "$tmp"
    curl -fsSL -o chisel.gz "https://github.com/jpillora/chisel/releases/download/${CH_TAG}/chisel_${CH_VER}_linux_amd64.gz" \
        && gunzip chisel.gz \
        && sudo mv chisel /opt/devilsec/tools/chisel \
        && sudo chmod +x /opt/devilsec/tools/chisel \
        && forge::link_tool /opt/devilsec/tools/chisel chisel \
        && forge::ok "chisel ${CH_TAG}"
    cd / && rm -rf "$tmp"
fi

# ─── 15. gowitness (screenshot recon) ─────────────────────────────────────────
forge::step "Installing gowitness"
GW_TAG=$(curl -fsSL https://api.github.com/repos/sensepost/gowitness/releases/latest 2>/dev/null \
    | grep -oP '"tag_name":\s*"\K[^"]+' | head -1)
if [[ -n "${GW_TAG:-}" ]]; then
    tmp=$(mktemp -d)
    cd "$tmp"
    GW_VER="${GW_TAG#v}"
    curl -fsSL -o gw.tar.gz \
        "https://github.com/sensepost/gowitness/releases/download/${GW_TAG}/gowitness-${GW_VER}-linux-amd64.tar.gz" 2>/dev/null \
        && tar xzf gw.tar.gz 2>/dev/null \
        && sudo mv gowitness /opt/devilsec/tools/ 2>/dev/null \
        && sudo chmod +x /opt/devilsec/tools/gowitness \
        && forge::link_tool /opt/devilsec/tools/gowitness gowitness \
        && forge::ok "gowitness ${GW_TAG}" \
        || forge::warn "gowitness archive format may have changed; skipping"
    cd / && rm -rf "$tmp"
fi

# ─── 16. ffuf (web fuzzer) ────────────────────────────────────────────────────
forge::step "Ensuring ffuf is available"
forge::apt_install ffuf

# ─── 17. Reverse shells generator (revshells.com style local copy) ────────────
forge::step "Installing rsg (reverse shell generator)"
pipx install --force "git+https://github.com/cytopia/shellpop" 2>&1 \
    | grep -E '(installed|apps)' | head -3 || true
[[ -x "$PIPX_BIN/shellpop" ]] && forge::link_tool "$PIPX_BIN/shellpop"

# ─── 18. Pretender (LLMNR/mDNS spoofer) ───────────────────────────────────────
forge::step "Installing Pretender"
PR_TAG=$(curl -fsSL https://api.github.com/repos/RedTeamPentesting/pretender/releases/latest 2>/dev/null \
    | grep -oP '"tag_name":\s*"\K[^"]+' | head -1)
if [[ -n "${PR_TAG:-}" ]]; then
    PR_VER="${PR_TAG#v}"
    tmp=$(mktemp -d)
    cd "$tmp"
    curl -fsSL -o pretender.tar.gz \
        "https://github.com/RedTeamPentesting/pretender/releases/download/${PR_TAG}/pretender_${PR_VER}_linux_amd64.tar.gz" 2>/dev/null \
        && tar xzf pretender.tar.gz 2>/dev/null \
        && sudo mv pretender /opt/devilsec/tools/ 2>/dev/null \
        && sudo chmod +x /opt/devilsec/tools/pretender \
        && forge::link_tool /opt/devilsec/tools/pretender pretender \
        && forge::ok "pretender ${PR_TAG}"
    cd / && rm -rf "$tmp"
fi

# ─── 19. PEAS suite & LinEnum (privesc) ───────────────────────────────────────
forge::step "Mirroring PEASS-ng scripts to /opt/devilsec/share/peass"
PEASS_DIR=/opt/devilsec/share/peass
if [[ ! -d "$PEASS_DIR" ]]; then
    git clone --depth=1 https://github.com/peass-ng/PEASS-ng.git "$PEASS_DIR" 2>/dev/null \
        && forge::ok "PEASS-ng cloned" \
        || forge::warn "Could not clone PEASS-ng"
else
    forge::info "PEASS-ng already present; pulling latest"
    (cd "$PEASS_DIR" && git pull --quiet) || true
fi

# Convenience launcher: 'peas-serve' starts an http server in the PEASS dir
sudo tee /opt/devilsec/bin/peas-serve >/dev/null <<'EOF'
#!/usr/bin/env bash
# Quick HTTP server in PEASS-ng, default port 8080
cd /opt/devilsec/share/peass
python3 -m http.server "${1:-8080}"
EOF
sudo chmod +x /opt/devilsec/bin/peas-serve

# ─── 20. Tool categorisation ─────────────────────────────────────────────────
# We write one file per category. devilsec-arsenal reads them at runtime and
# pretty-prints. The 'pivoting' file is also written during the ligolo step
# above; we overwrite it here only to ensure both ligolo and chisel are listed
# together regardless of which one was installed first.
forge::step "Writing tool category index"
sudo mkdir -p /opt/devilsec/share/categories

sudo tee /opt/devilsec/share/categories/active-directory.list >/dev/null <<EOF
nxc               NetExec — the network execution multitool
netexec           NetExec (alias)
nxcdb             NetExec database CLI
bloodyAD          unauth/auth AD modification toolkit
bloodhound-python AD collector for BloodHound CE
bloodhound-ce     BloodHound CE controller (docker compose wrapper)
certipy           ADCS attacks (ESC1..ESC15)
certipy-ad        Certipy alias
kerbrute          Kerberos username & password sprayer
evil-winrm        WinRM shell with helpers
EOF

sudo tee /opt/devilsec/share/categories/impacket.list >/dev/null <<EOF
psexec.py         remote shell via SCM
smbexec.py        remote shell via service abuse
wmiexec.py        remote shell via DCOM/WMI
atexec.py         remote shell via at/schtasks
dcomexec.py       remote shell via DCOM
secretsdump.py    DRSUAPI / NTDS / SAM / LSA dumper
GetUserSPNs.py    Kerberoast SPN enumeration
GetNPUsers.py     AS-REP roasting
getTGT.py         request a TGT
getST.py          request a service ticket (S4U2self/proxy)
ticketer.py       forge silver/golden tickets
ntlmrelayx.py     SMB/HTTP/LDAP NTLM relay multitool
mssqlclient.py    MSSQL interactive client
rpcdump.py        RPC endpoint enumeration
samrdump.py       SAMR enumeration
lookupsid.py      RID brute via LSARPC
reg.py            remote registry
services.py       remote service control
smbserver.py      lightweight SMB server
smbclient.py      lightweight SMB client
findDelegation.py find delegations in AD
describeTicket.py inspect a .ccache/.kirbi
EOF

sudo tee /opt/devilsec/share/categories/pivoting.list >/dev/null <<EOF
ligolo            ligolo-ng helper (proxy + staged Win/Linux agents)
ligolo-proxy      ligolo-ng operator-side proxy
chisel            jpillora/chisel — TCP/UDP tunneling over HTTP
EOF

sudo tee /opt/devilsec/share/categories/relay-coercion.list >/dev/null <<EOF
coercer           authentication coercion multitool (printerbug, PetitPotam…)
Coercer           Coercer (canonical name)
mitm6             SLAAC/DHCPv6 takeover for NTLM relay
pretender        LLMNR/mDNS/NBT-NS spoofer
donpapi           offline DPAPI secret harvester
EOF

sudo tee /opt/devilsec/share/categories/recon-web.list >/dev/null <<EOF
ffuf              fast web fuzzer
gowitness         headless screenshot recon
enum4linux-ng     SMB/RPC enumeration (rewrite of enum4linux)
EOF

sudo tee /opt/devilsec/share/categories/privesc-postexp.list >/dev/null <<EOF
peas-serve        serve PEASS-ng scripts on :8080 (default)
updog             quick HTTPS file server
shellpop          reverse-shell one-liner generator
EOF

# ─── 21. arsenal viewer (categorised, paginated, colour-aware) ──────────────
sudo tee /opt/devilsec/bin/devilsec-arsenal >/dev/null <<'ARSENAL_EOF'
#!/usr/bin/env bash
# DEVILSEC · arsenal viewer
#
# Usage:
#   devilsec-arsenal              show every category
#   devilsec-arsenal <category>   show one category (e.g. 'pivoting')
#   devilsec-arsenal --list       list category names only
#   devilsec-arsenal --raw        flat list (one binary per line)
#   devilsec-arsenal --search X   fuzzy match across all categories

set -uo pipefail

CAT_DIR=/opt/devilsec/share/categories
BIN_DIR=/opt/devilsec/bin

if [[ -t 1 ]]; then
    C_R=$'\033[0m'; C_B=$'\033[1m'; C_D=$'\033[2m'
    C_VIOLET=$'\033[38;2;138;43;226m'
    C_CRIMSON=$'\033[38;2;220;38;65m'
    C_GOLD=$'\033[38;2;212;175;55m'
    C_ASH=$'\033[38;2;120;120;140m'
    C_FG=$'\033[38;2;232;227;242m'
else
    C_R="" C_B="" C_D="" C_VIOLET="" C_CRIMSON="" C_GOLD="" C_ASH="" C_FG=""
fi

# Pretty category title from filename (active-directory.list → Active Directory)
__title() {
    local stem="${1%.list}"
    stem="${stem//-/ }"
    # Capitalise each word
    awk '{for(i=1;i<=NF;i++)$i=toupper(substr($i,1,1))substr($i,2)}1' <<<"$stem"
}

# Render a single category file
__render_category() {
    local file="$1"
    local title
    title=$(__title "$(basename "$file")")
    printf '\n  %s%s┃%s  %s%s%s\n' "$C_VIOLET" "$C_B" "$C_R" "$C_B" "$title" "$C_R"
    printf '  %s%s%s\n' "$C_VIOLET" "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "$C_R"
    while IFS= read -r line; do
        # Skip blanks/comments
        [[ -z "$line" || "$line" =~ ^# ]] && continue
        local tool desc
        tool=$(awk '{print $1}' <<<"$line")
        desc=$(cut -d' ' -f2- <<<"$line" | sed -E 's/^\s+//')
        # Mark as missing in dim
        if [[ -x "$BIN_DIR/$tool" || -x "$(command -v "$tool" 2>/dev/null)" ]]; then
            printf '    %s▸%s %s%-20s%s %s%s%s\n' \
                "$C_CRIMSON" "$C_R" "$C_FG" "$tool" "$C_R" "$C_ASH" "$desc" "$C_R"
        else
            printf '    %s▸%s %s%-20s  %s(missing)%s %s%s%s\n' \
                "$C_D" "$C_R" "$C_D" "$tool" "$C_GOLD" "$C_D" "$C_ASH" "$desc" "$C_R"
        fi
    done < "$file"
}

case "${1:-}" in
    --list|-l)
        for f in "$CAT_DIR"/*.list; do
            __title "$(basename "$f")"
        done
        ;;
    --raw)
        ls -1 "$BIN_DIR" | sort
        ;;
    --search|-s)
        kw="${2:-}"; [[ -z "$kw" ]] && { echo "usage: devilsec-arsenal --search <kw>"; exit 1; }
        grep -i --color=auto -H "$kw" "$CAT_DIR"/*.list | sed "s|$CAT_DIR/||"
        ;;
    "")
        # Banner
        printf '\n  %s%s▓ DEVILSEC arsenal%s  %severything in /opt/devilsec/bin, always on $PATH%s\n' \
            "$C_B" "$C_VIOLET" "$C_R" "$C_D" "$C_R"
        # All categories, in alphabetical order, but with active-directory first
        if [[ -f "$CAT_DIR/active-directory.list" ]]; then
            __render_category "$CAT_DIR/active-directory.list"
        fi
        if [[ -f "$CAT_DIR/impacket.list" ]]; then
            __render_category "$CAT_DIR/impacket.list"
        fi
        if [[ -f "$CAT_DIR/pivoting.list" ]]; then
            __render_category "$CAT_DIR/pivoting.list"
        fi
        if [[ -f "$CAT_DIR/relay-coercion.list" ]]; then
            __render_category "$CAT_DIR/relay-coercion.list"
        fi
        if [[ -f "$CAT_DIR/recon-web.list" ]]; then
            __render_category "$CAT_DIR/recon-web.list"
        fi
        if [[ -f "$CAT_DIR/privesc-postexp.list" ]]; then
            __render_category "$CAT_DIR/privesc-postexp.list"
        fi
        printf '\n  %sHint:%s  devilsec-arsenal <category>  ·  --search <kw>  ·  --list\n\n' "$C_ASH" "$C_R"
        ;;
    *)
        # Try to match a category by stem
        match=$(ls "$CAT_DIR" 2>/dev/null | grep -i "^${1}" | head -1)
        if [[ -n "$match" ]]; then
            __render_category "$CAT_DIR/$match"
            echo
        else
            echo "unknown category: $1"
            echo "available: $(ls "$CAT_DIR" | sed 's/\.list$//' | tr '\n' ' ')"
            exit 1
        fi
        ;;
esac
ARSENAL_EOF
sudo chmod +x /opt/devilsec/bin/devilsec-arsenal

forge::ok "Offensive arsenal forged"
forge::hint "Run 'devilsec-arsenal' for the full catalogue."
forge::hint "Run 'devilsec-arsenal pivoting' for the Pivoting category only."
forge::hint "Run 'ligolo' for the pivoting helper (proxy + staged agents)."
