#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║                                                                          ║
# ║    ██████╗ ███████╗██╗   ██╗██╗██╗     ███████╗███████╗ ██████╗         ║
# ║    ██╔══██╗██╔════╝██║   ██║██║██║     ██╔════╝██╔════╝██╔════╝         ║
# ║    ██║  ██║█████╗  ██║   ██║██║██║     ███████╗█████╗  ██║              ║
# ║    ██║  ██║██╔══╝  ╚██╗ ██╔╝██║██║     ╚════██║██╔══╝  ██║              ║
# ║    ██████╔╝███████╗ ╚████╔╝ ██║███████╗███████║███████╗╚██████╗         ║
# ║    ╚═════╝ ╚══════╝  ╚═══╝  ╚═╝╚══════╝╚══════╝╚══════╝ ╚═════╝         ║
# ║                                                                          ║
# ║              The DEVILSEC Environment Summoner · v1.1.0                  ║
# ║            "Power, given by others, is never truly yours."               ║
# ║                                                                          ║
# ║  Author : DEVILSEC                                                       ║
# ║  Target : Kali Linux (rolling)                                           ║
# ║  License: MIT                                                            ║
# ║                                                                          ║
# ╚══════════════════════════════════════════════════════════════════════════╝

set -uo pipefail

# ─── Path resolution ──────────────────────────────────────────────────────────
DEVILSEC_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
export DEVILSEC_ROOT

# Source the core forge (utilities, palette, logger, executor)
source "$DEVILSEC_ROOT/core/forge.sh"

# ─── Guard rails ──────────────────────────────────────────────────────────────
if [[ $EUID -eq 0 ]]; then
    forge::fatal "DEVILSEC must not be summoned as root."
    forge::hint "The forge will request privileges itself when needed."
    exit 1
fi

if [[ ! -f /etc/os-release ]] || ! grep -qi "kali" /etc/os-release; then
    forge::warn "This forge was tempered for Kali Linux."
    forge::ask "Continue anyway? [y/N]" answer
    [[ "${answer,,}" =~ ^y(es)?$ ]] || exit 0
fi

# ─── Banner ───────────────────────────────────────────────────────────────────
clear
forge::banner

# ─── The Pact ─────────────────────────────────────────────────────────────────
cat <<EOF

  ${C_VIOLET}┃${C_RESET}  ${C_BOLD}The Pact${C_RESET}
  ${C_VIOLET}┃${C_RESET}
  ${C_VIOLET}┃${C_RESET}  DEVILSEC will reshape your system. Specifically, it will:
  ${C_VIOLET}┃${C_RESET}
  ${C_VIOLET}┃${C_RESET}    ${C_CRIMSON}»${C_RESET} Install bspwm, polybar, picom, sxhkd, kitty, rofi
  ${C_VIOLET}┃${C_RESET}    ${C_CRIMSON}»${C_RESET} Forge offensive arsenals (impacket, netexec, bloodyad…)
  ${C_VIOLET}┃${C_RESET}    ${C_CRIMSON}»${C_RESET} Deploy BloodHound CE (containerised, opt-in)
  ${C_VIOLET}┃${C_RESET}    ${C_CRIMSON}»${C_RESET} Bind every tool into \$PATH via /opt/devilsec
  ${C_VIOLET}┃${C_RESET}    ${C_CRIMSON}»${C_RESET} Overwrite your dotfiles (a backup is made first)
  ${C_VIOLET}┃${C_RESET}    ${C_CRIMSON}»${C_RESET} Register the 'styx' control panel (your one-key console)
  ${C_VIOLET}┃${C_RESET}
  ${C_VIOLET}┃${C_RESET}  A reboot is required at the end.
  ${C_VIOLET}┃${C_RESET}

EOF

forge::ask "Do you accept the pact? [y/N]" pact_answer
if ! [[ "${pact_answer,,}" =~ ^y(es)?$ ]]; then
    forge::info "Pact declined. Nothing was changed."
    exit 0
fi

# ─── Flight plan: ordered phases ──────────────────────────────────────────────
# Each phase is a self-contained script. Re-runnable, idempotent, traceable.
PHASES=(
    "00-preflight:Preflight checks & system update"
    "10-base:Base packages & build dependencies"
    "20-wm:bspwm · sxhkd · picom · polybar"
    "30-shell:zsh · kitty · starship prompt"
    "40-tools:Offensive toolchain (impacket, nxc, bloodyAD…)"
    "50-bloodhound:BloodHound CE (containerised, opt-in)"
    "60-wordlists:SecLists + curated dictionaries"
    "70-dotfiles:Deploy DEVILSEC dotfiles & themes"
    "80-styx:Install the 'styx' control panel"
    "99-postflight:Finalisation & sealing"
)

TOTAL_PHASES=${#PHASES[@]}
PHASE_LOG="$DEVILSEC_ROOT/.summon.log"
: > "$PHASE_LOG"

forge::info "Logging all output to ${PHASE_LOG}"
echo

START_TIME=$(date +%s)

for idx in "${!PHASES[@]}"; do
    entry="${PHASES[$idx]}"
    phase_id="${entry%%:*}"
    phase_desc="${entry#*:}"
    phase_num=$((idx + 1))

    forge::phase_header "$phase_num" "$TOTAL_PHASES" "$phase_desc"

    phase_script="$DEVILSEC_ROOT/core/phases/${phase_id}.sh"
    if [[ ! -x "$phase_script" ]]; then
        forge::warn "Phase script missing or non-executable: $phase_script"
        forge::ask "Skip and continue? [y/N]" skip_ans
        [[ "${skip_ans,,}" =~ ^y(es)?$ ]] || exit 1
        continue
    fi

    if "$phase_script" 2>&1 | tee -a "$PHASE_LOG" | forge::stream_indent; then
        forge::ok "Phase ${phase_num}/${TOTAL_PHASES} complete · ${phase_desc}"
    else
        forge::err "Phase ${phase_num}/${TOTAL_PHASES} failed · ${phase_desc}"
        forge::hint "Inspect ${PHASE_LOG} for details."
        forge::ask "Continue anyway? [y/N]" cont_ans
        [[ "${cont_ans,,}" =~ ^y(es)?$ ]] || exit 1
    fi
    echo
done

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))
ELAPSED_FMT=$(printf '%02d:%02d:%02d' $((ELAPSED/3600)) $(((ELAPSED%3600)/60)) $((ELAPSED%60)))

# ─── Seal ─────────────────────────────────────────────────────────────────────
cat <<EOF

  ${C_VIOLET}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${C_RESET}
  ${C_VIOLET}┃${C_RESET}                                                                      ${C_VIOLET}┃${C_RESET}
  ${C_VIOLET}┃${C_RESET}   ${C_BOLD}${C_CRIMSON}The pact is sealed.${C_RESET}                                              ${C_VIOLET}┃${C_RESET}
  ${C_VIOLET}┃${C_RESET}                                                                      ${C_VIOLET}┃${C_RESET}
  ${C_VIOLET}┃${C_RESET}   Elapsed : ${C_BOLD}${ELAPSED_FMT}${C_RESET}                                              ${C_VIOLET}┃${C_RESET}
  ${C_VIOLET}┃${C_RESET}   Log     : ${PHASE_LOG}     ${C_VIOLET}┃${C_RESET}
  ${C_VIOLET}┃${C_RESET}                                                                      ${C_VIOLET}┃${C_RESET}
  ${C_VIOLET}┃${C_RESET}   Next steps:                                                        ${C_VIOLET}┃${C_RESET}
  ${C_VIOLET}┃${C_RESET}     ${C_CRIMSON}1.${C_RESET} Reboot your machine                                            ${C_VIOLET}┃${C_RESET}
  ${C_VIOLET}┃${C_RESET}     ${C_CRIMSON}2.${C_RESET} On the login screen, choose 'bspwm'                            ${C_VIOLET}┃${C_RESET}
  ${C_VIOLET}┃${C_RESET}     ${C_CRIMSON}3.${C_RESET} Run ${C_BOLD}styx${C_RESET} to customise everything                            ${C_VIOLET}┃${C_RESET}
  ${C_VIOLET}┃${C_RESET}                                                                      ${C_VIOLET}┃${C_RESET}
  ${C_VIOLET}┃${C_RESET}   ${C_BOLD}— DEVILSEC${C_RESET}                                                         ${C_VIOLET}┃${C_RESET}
  ${C_VIOLET}┃${C_RESET}                                                                      ${C_VIOLET}┃${C_RESET}
  ${C_VIOLET}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${C_RESET}

EOF

forge::ask "Reboot now? [y/N]" reboot_ans
if [[ "${reboot_ans,,}" =~ ^y(es)?$ ]]; then
    forge::info "Rebooting in 3 seconds…"
    sleep 3
    sudo reboot
fi
