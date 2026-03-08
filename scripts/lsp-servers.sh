#!/usr/bin/env bash
# Install language servers for Helix

header "Installing language servers"

info "Checking language servers..."

# Rust
if command -v rust-analyzer &>/dev/null; then
    echo "  - rust-analyzer (installed)"
else
    echo "  - rust-analyzer (installing via rustup...)"
    rustup component add rust-analyzer 2>/dev/null || warn "rustup not found, install rust-analyzer manually"
fi

# Python
if command -v ruff &>/dev/null; then
    echo "  - ruff (installed)"
else
    echo "  - ruff (installing...)"
    brew install ruff
fi

if command -v pyright-langserver &>/dev/null || command -v pyright &>/dev/null; then
    echo "  - pyright (installed)"
else
    echo "  - pyright (installing...)"
    npm install -g pyright 2>/dev/null || warn "npm not found, install pyright manually"
fi

# TypeScript
if command -v typescript-language-server &>/dev/null; then
    echo "  - typescript-language-server (installed)"
else
    echo "  - typescript-language-server (installing...)"
    npm install -g typescript typescript-language-server 2>/dev/null || warn "npm not found, install manually"
fi

# YAML
if command -v yaml-language-server &>/dev/null; then
    echo "  - yaml-language-server (installed)"
else
    echo "  - yaml-language-server (installing...)"
    npm install -g yaml-language-server 2>/dev/null || warn "npm not found, install manually"
fi

# Bash
if command -v bash-language-server &>/dev/null; then
    echo "  - bash-language-server (installed)"
else
    echo "  - bash-language-server (installing...)"
    npm install -g bash-language-server 2>/dev/null || warn "npm not found, install manually"
fi

# TOML
if command -v taplo &>/dev/null; then
    echo "  - taplo (installed)"
else
    echo "  - taplo (installing...)"
    brew install taplo
fi
