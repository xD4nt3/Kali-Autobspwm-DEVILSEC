#!/usr/bin/env bash
# core/forge.sh — DEVILSEC shared utilities, palette and logger.
# Sourced by install.sh and every phase script.

# ─── Palette ──────────────────────────────────────────────────────────────────
# The DEVILSEC palette — onyx, crimson, violet, ember.
if [[ -t 1 ]]; then
    C_RESET=$'\033[0m'
    C_BOLD=$'\033[1m'
    C_DIM=$'\033[2m'
    C_ITALIC=$'\033[3m'

    C_ONYX=$'\033[38;2;20;20;26m'
    C_ASH=$'\033[38;2;120;120;140m'
    C_FOG=$'\033[38;2;200;200;215m'
    C_CRIMSON=$'\033[38;2;220;38;65m'
    C_BLOOD=$'\033[38;2;139;0;30m'
    C_VIOLET=$'\033[38;2;138;43;226m'
    C_PURPLE=$'\033[38;2;88;28;135m'
    C_EMBER=$'\033[38;2;255;94;77m'
    C_GOLD=$'\033[38;2;212;175;55m'
else
    C_RESET="" C_BOLD="" C_DIM="" C_ITALIC=""
    C_ONYX="" C_ASH="" C_FOG="" C_CRIMSON="" C_BLOOD=""
    C_VIOLET="" C_PURPLE="" C_EMBER="" C_GOLD=""
fi
export C_RESET C_BOLD C_DIM C_ITALIC
export C_ONYX C_ASH C_FOG C_CRIMSON C_BLOOD C_VIOLET C_PURPLE C_EMBER C_GOLD

# ─── Glyphs ───────────────────────────────────────────────────────────────────
G_DAGGER="†"
G_BULLET="•"
G_ARROW="▸"
G_CHECK="✓"
G_CROSS="✗"
G_WARN="!"
G_INFO="i"
G_GEAR="⚙"
G_SPARK="✦"
export G_DAGGER G_BULLET G_ARROW G_CHECK G_CROSS G_WARN G_INFO G_GEAR G_SPARK

# ─── Logger ───────────────────────────────────────────────────────────────────
forge::info()  { printf '  %s%s%s  %s\n' "$C_VIOLET" "$G_INFO" "$C_RESET" "$*"; }
forge::ok()    { printf '  %s%s%s  %s\n' "$C_GOLD"   "$G_CHECK" "$C_RESET" "$*"; }
forge::warn()  { printf '  %s%s%s  %s\n' "$C_EMBER"  "$G_WARN"  "$C_RESET" "$*" >&2; }
forge::err()   { printf '  %s%s%s  %s\n' "$C_CRIMSON" "$G_CROSS" "$C_RESET" "$*" >&2; }
forge::fatal() { printf '\n  %s%s FATAL %s  %s\n\n' "$C_BOLD$C_CRIMSON" "$G_DAGGER" "$C_RESET" "$*" >&2; }
forge::hint()  { printf '  %s%s%s  %s%s%s\n' "$C_ASH" "$G_ARROW" "$C_RESET" "$C_DIM" "$*" "$C_RESET"; }
forge::step()  { printf '  %s%s%s  %s\n' "$C_PURPLE" "$G_ARROW" "$C_RESET" "$*"; }

# ─── Interactive helpers ──────────────────────────────────────────────────────
# forge::ask <prompt> <varname>
forge::ask() {
    local prompt="$1" var="$2" reply
    printf '\n  %s%s%s  %s ' "$C_CRIMSON" "$G_DAGGER" "$C_RESET" "$prompt"
    IFS= read -r reply
    printf -v "$var" '%s' "$reply"
}

# forge::select <prompt> <option1> <option2> ...
# Prints the chosen option to stdout.
forge::select() {
    local prompt="$1"; shift
    local -a opts=("$@")
    local i choice
    echo
    printf '  %s%s%s\n' "$C_BOLD" "$prompt" "$C_RESET"
    for i in "${!opts[@]}"; do
        printf '    %s%d.%s  %s\n' "$C_VIOLET" "$((i+1))" "$C_RESET" "${opts[$i]}"
    done
    while :; do
        printf '\n  %s%s%s  choice [1-%d] ' "$C_CRIMSON" "$G_DAGGER" "$C_RESET" "${#opts[@]}"
        IFS= read -r choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#opts[@]} )); then
            printf '%s\n' "${opts[$((choice-1))]}"
            return 0
        fi
        forge::warn "Invalid selection."
    done
}

# Indent every line of a piped stream (visual sub-process output)
forge::stream_indent() {
    sed -u 's/^/    /'
}

# ─── Banner ───────────────────────────────────────────────────────────────────
forge::banner() {
cat <<EOF

${C_PURPLE}        ▓█████▄  ▓█████ ██▒   █▓ ██▓ ██▓      ██████ ▓█████  ▄████▄  ${C_RESET}
${C_PURPLE}        ▒██▀ ██▌ ▓█   ▀▓██░   █▒▓██▒▓██▒    ▒██    ▒ ▓█   ▀ ▒██▀ ▀█  ${C_RESET}
${C_VIOLET}        ░██   █▌ ▒███   ▓██  █▒░▒██▒▒██░    ░ ▓██▄   ▒███   ▒▓█    ▄ ${C_RESET}
${C_CRIMSON}        ░▓█▄   ▌ ▒▓█  ▄  ▒██ █░░░██░▒██░      ▒   ██▒▒▓█  ▄ ▒▓▓▄ ▄██▒${C_RESET}
${C_CRIMSON}        ░▒████▓  ░▒████▒  ▒▀█░  ░██░░██████▒▒██████▒▒░▒████▒▒ ▓███▀ ░${C_RESET}
${C_BLOOD}         ▒▒▓  ▒  ░░ ▒░ ░  ░ ▐░  ░▓  ░ ▒░▓  ░▒ ▒▓▒ ▒ ░░░ ▒░ ░░ ░▒ ▒  ░${C_RESET}

              ${C_DIM}${C_ASH}an offensive desktop environment for Kali Linux${C_RESET}
                       ${C_VIOLET}${G_SPARK}${C_RESET}  ${C_DIM}v1.1.0 · "Inferno"${C_RESET}  ${C_VIOLET}${G_SPARK}${C_RESET}

EOF
}

# ─── Phase header ─────────────────────────────────────────────────────────────
# forge::phase_header <num> <total> <description>
forge::phase_header() {
    local num="$1" total="$2" desc="$3"
    local width=72
    local label="  PHASE ${num}/${total}  ·  ${desc}  "
    local pad=$(( width - ${#label} ))
    (( pad < 0 )) && pad=0
    printf '\n  %s┏' "$C_VIOLET"
    printf '━%.0s' $(seq 1 $width)
    printf '┓%s\n' "$C_RESET"
    printf '  %s┃%s%s%s%*s%s┃%s\n' \
        "$C_VIOLET" "$C_BOLD" "$label" "$C_RESET" "$pad" "" "$C_VIOLET" "$C_RESET"
    printf '  %s┗' "$C_VIOLET"
    printf '━%.0s' $(seq 1 $width)
    printf '┛%s\n\n' "$C_RESET"
}

# ─── apt wrapper ──────────────────────────────────────────────────────────────
# Quiet, polite, and idempotent. Single update per run.
__forge_apt_updated=0
forge::apt_update() {
    if (( __forge_apt_updated == 0 )); then
        forge::step "Refreshing package index…"
        sudo apt-get update -qq
        __forge_apt_updated=1
    fi
}

forge::apt_install() {
    local pkgs=("$@") missing=()
    for p in "${pkgs[@]}"; do
        if ! dpkg -s "$p" &>/dev/null; then
            missing+=("$p")
        fi
    done
    if (( ${#missing[@]} == 0 )); then
        forge::info "All requested packages already present: ${pkgs[*]}"
        return 0
    fi
    forge::apt_update
    forge::step "Installing: ${missing[*]}"
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "${missing[@]}"
}

# ─── pipx wrapper ─────────────────────────────────────────────────────────────
forge::pipx_install() {
    local spec="$1" name="${2:-}"
    if [[ -n "$name" ]] && pipx list 2>/dev/null | grep -q "package $name "; then
        forge::info "pipx package already present: $name"
        return 0
    fi
    forge::step "pipx install ${spec}"
    pipx install --force "$spec"
}

# ─── Backup helper ────────────────────────────────────────────────────────────
forge::backup() {
    local path="$1"
    [[ -e "$path" ]] || return 0
    local stamp; stamp=$(date +%Y%m%d-%H%M%S)
    local dest="${path}.devilsec-bak-${stamp}"
    forge::info "Backing up: $path → $dest"
    cp -a "$path" "$dest"
}

# ─── Path management ──────────────────────────────────────────────────────────
# Symlink a binary into /opt/devilsec/bin (which is on $PATH).
forge::link_tool() {
    local source_bin="$1" name="${2:-$(basename "$1")}"
    [[ -e "$source_bin" ]] || { forge::warn "link_tool: missing $source_bin"; return 1; }
    sudo mkdir -p /opt/devilsec/bin
    sudo ln -sf "$source_bin" "/opt/devilsec/bin/$name"
}

export -f forge::info forge::ok forge::warn forge::err forge::fatal
export -f forge::hint forge::step forge::ask forge::select
export -f forge::stream_indent forge::banner forge::phase_header
export -f forge::apt_update forge::apt_install forge::pipx_install
export -f forge::backup forge::link_tool
