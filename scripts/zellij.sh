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
ZELLIJ_CFG
else
    warn "Zellij config already exists, skipping"
fi

if [[ ! -f "$ZELLIJ_DIR/layouts/dev.kdl" ]]; then
    info "Writing Zellij dev layout (yazelix-style)"
    cat > "$ZELLIJ_DIR/layouts/dev.kdl" << 'ZELLIJ_LAYOUT'
// Dev layout: file sidebar + editor + terminal
layout {
    // Top bar
    pane size=1 borderless=true {
        plugin location="tab-bar"
    }

    pane split_direction="vertical" {
        // File sidebar (yazi)
        pane size="20%" {
            command "yazi"
        }
        // Main editing area
        pane split_direction="horizontal" {
            // Editor (large)
            pane size="75%" {
                command "hx"
                args "."
                focus true
            }
            // Terminal below editor
            pane size="25%"
        }
    }

    // Status bar
    pane size=1 borderless=true {
        plugin location="status-bar"
    }
}
ZELLIJ_LAYOUT
else
    warn "Zellij dev layout already exists, skipping"
fi
