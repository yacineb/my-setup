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
    chojs23/tap/ec  # terminal 3-way merge tool
    nb             # CLI note-taking, bookmarking, archiving
    gitmoji
    fzf
    jq
    tokei      # code statistics
    ast-grep   # structural search/replace using AST patterns
    duf        # better df — disk usage/free with a clean TUI
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
