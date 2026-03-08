#!/usr/bin/env bash
# Install Homebrew and all packages

header "Checking Homebrew"

if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    info "Homebrew already installed"
fi

header "Installing packages"

FORMULAE=(
    helix
    zellij
    yazi       # file manager (pulls in ffmpeg, poppler, etc. for previews)
    lazygit
    starship
    zoxide
    ripgrep
    fd
    bat
    git-delta
    fzf
    jq
    tokei      # code statistics
)

CASKS=(
    ghostty
    font-jetbrains-mono-nerd-font
)

info "Installing formulae..."
for pkg in "${FORMULAE[@]}"; do
    if brew list "$pkg" &>/dev/null; then
        echo "  - $pkg (already installed)"
    else
        echo "  - $pkg (installing...)"
        brew install "$pkg"
    fi
done

info "Installing casks..."
for cask in "${CASKS[@]}"; do
    if brew list --cask "$cask" &>/dev/null; then
        echo "  - $cask (already installed)"
    else
        echo "  - $cask (installing...)"
        brew install --cask "$cask"
    fi
done
