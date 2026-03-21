#!/usr/bin/env bash
# Configure Ghostty terminal emulator

header "Configuring Ghostty"

GHOSTTY_DIR="$HOME/.config/ghostty"
mkdir -p "$GHOSTTY_DIR"

if [[ ! -f "$GHOSTTY_DIR/config" ]]; then
    info "Writing Ghostty config"
    cat > "$GHOSTTY_DIR/config" << 'GHOSTTY'
# Font
font-family = JetBrainsMono Nerd Font
font-size = 14

# Theme — clean dark
theme = Catppuccin Mocha

# Window
window-padding-x = 8
window-padding-y = 8
window-decoration = true
macos-titlebar-style = tabs
window-save-state = always

# Behavior
copy-on-select = clipboard
confirm-close-surface = false
mouse-hide-while-typing = true
cursor-style = bar
cursor-style-blink = false
shell-integration = zsh

# Performance
auto-update = check
GHOSTTY
else
    warn "Ghostty config already exists, skipping"
fi
