#!/usr/bin/env bash
# Set up shell integrations in .zshrc

header "Shell integration"

ZSHRC="$HOME/.zshrc"
MARKER="# --- terminal-dev-setup ---"

if ! grep -q "$MARKER" "$ZSHRC" 2>/dev/null; then
    info "Adding shell integrations to .zshrc"
    cat >> "$ZSHRC" << SHELL

$MARKER
# Starship prompt
eval "\$(starship init zsh)"

# Zoxide (smart cd)
eval "\$(zoxide init zsh)"

# fzf keybindings
source <(fzf --zsh)

# Aliases
alias lg="lazygit"
alias y="yazi"
alias e="hx"
alias cat="bat --plain"
alias ls="ls --color=auto"
alias ll="ls -la"
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline -20"

# Helix as default editor
export EDITOR="hx"
export VISUAL="hx"

# Yazi: cd to directory on exit (Ctrl+Q)
function ya() {
    local tmp="\$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "\$@" --cwd-file="\$tmp"
    if cwd="\$(cat -- "\$tmp")" && [ -n "\$cwd" ] && [ "\$cwd" != "\$PWD" ]; then
        cd -- "\$cwd"
    fi
    rm -f -- "\$tmp"
}
$MARKER
SHELL
else
    warn "Shell integrations already present in .zshrc, skipping"
fi
