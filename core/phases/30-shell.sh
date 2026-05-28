#!/usr/bin/env bash
# Phase 30 · Shell · zsh, starship, plugins
set -uo pipefail
source "$DEVILSEC_ROOT/core/forge.sh"

forge::step "Installing zsh and friends"
forge::apt_install zsh zsh-autosuggestions zsh-syntax-highlighting

# Starship prompt — fast, modern, replaces powerlevel10k
if ! command -v starship &>/dev/null; then
    forge::step "Installing starship prompt"
    curl -sS https://starship.rs/install.sh | sudo sh -s -- --yes --bin-dir /usr/local/bin >/dev/null
    forge::ok "starship installed"
else
    forge::info "starship already installed"
fi

# zsh as default shell for the current user
if [[ "$SHELL" != *zsh ]]; then
    forge::step "Setting zsh as default shell for ${USER}"
    sudo chsh -s "$(command -v zsh)" "$USER" || forge::warn "Could not chsh; do it manually"
fi

# Useful zsh plugins (these are also in apt but we want consistent paths)
ZSH_PLUGIN_DIR="$HOME/.zsh-plugins"
mkdir -p "$ZSH_PLUGIN_DIR"

declare -A plugins=(
    [fzf-tab]=https://github.com/Aloxaf/fzf-tab.git
    [zsh-history-substring-search]=https://github.com/zsh-users/zsh-history-substring-search.git
    [zsh-completions]=https://github.com/zsh-users/zsh-completions.git
)
for name in "${!plugins[@]}"; do
    target="$ZSH_PLUGIN_DIR/$name"
    if [[ ! -d "$target" ]]; then
        git clone --depth=1 "${plugins[$name]}" "$target" 2>/dev/null \
            && forge::ok "Cloned $name" \
            || forge::warn "Could not clone $name"
    fi
done

forge::ok "Shell layer ready"
