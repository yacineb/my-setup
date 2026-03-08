#!/usr/bin/env bash
# Configure Zellij session/pane manager

header "Configuring Zellij"

ZELLIJ_DIR="$HOME/.config/zellij"
mkdir -p "$ZELLIJ_DIR/layouts"

if [[ ! -f "$ZELLIJ_DIR/config.kdl" ]]; then
    info "Writing Zellij config"
    cat > "$ZELLIJ_DIR/config.kdl" << 'ZELLIJ_CFG'
// Zellij config

theme "catppuccin-mocha"
default_layout "dev"
pane_frames false
default_shell "zsh"
scrollback_editor "hx"
copy_on_select true

// Simplified UI
simplified_ui true

// Keybindings
keybinds {
    shared {
        // Ctrl+g → open lazygit in a fullscreen floating pane
        bind "Ctrl g" {
            Run "lazygit" {
                direction "Down"
            }
        }
    }
}
ZELLIJ_CFG
else
    warn "Zellij config already exists, skipping"
fi

if [[ ! -f "$ZELLIJ_DIR/layouts/dev.kdl" ]]; then
    info "Writing Zellij dev layout (VS Code-style)"
    cat > "$ZELLIJ_DIR/layouts/dev.kdl" << 'ZELLIJ_LAYOUT'
// VS Code-style layout: sidebar + editor + bottom terminal
layout {
    // Top tab bar
    pane size=1 borderless=true {
        plugin location="tab-bar"
    }

    pane split_direction="vertical" {
        // Left sidebar — file browser
        pane size="25%" {
            command "yazi"
        }
        // Right main area — editor on top, terminal on bottom
        pane split_direction="horizontal" {
            // Editor
            pane size="70%" {
                command "hx"
                args "."
                focus true
            }
            // Bottom terminal
            pane size="30%"
        }
    }

    // Bottom status bar
    pane size=1 borderless=true {
        plugin location="status-bar"
    }
}
ZELLIJ_LAYOUT
else
    warn "Zellij dev layout already exists, skipping"
fi
