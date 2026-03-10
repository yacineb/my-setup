#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Terminal-First Dev Environment Setup for macOS
# Stack: Ghostty + Zellij + Helix + Yazi + Lazygit + Starship + utilities
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load shared helpers
source "$SCRIPT_DIR/scripts/common.sh"

# Run each setup script in order
source "$SCRIPT_DIR/scripts/homebrew.sh"
source "$SCRIPT_DIR/scripts/ghostty.sh"
source "$SCRIPT_DIR/scripts/helix.sh"
source "$SCRIPT_DIR/scripts/zellij.sh"
source "$SCRIPT_DIR/scripts/yazi.sh"
source "$SCRIPT_DIR/scripts/lazygit.sh"
source "$SCRIPT_DIR/scripts/starship.sh"
source "$SCRIPT_DIR/scripts/git-delta.sh"
source "$SCRIPT_DIR/scripts/shell.sh"
source "$SCRIPT_DIR/scripts/lsp-servers.sh"

# Done
header "Setup complete"

info "Restart your terminal (or run: source ~/.zshrc)"
echo ""
echo "  Quick start:"
echo "    ghostty          → open the new terminal"
echo "    zellij            → start session with dev layout"
echo "    hx --tutor        → learn Helix keybindings"
echo "    lazygit           → git UI"
echo "    ya                → yazi with cd-on-exit"
echo ""
echo "  All configs live in ~/.config/{ghostty,helix,zellij,yazi}/"
echo "  Lazygit config: ~/Library/Application Support/lazygit/config.yml"
echo "  Merge tool:     ec (terminal 3-way merge)"
echo ""
info "Happy hacking!"
