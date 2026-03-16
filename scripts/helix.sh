#!/usr/bin/env bash
# Configure Helix editor

header "Configuring Helix"

HELIX_DIR="$HOME/.config/helix"
mkdir -p "$HELIX_DIR"

if [[ ! -f "$HELIX_DIR/config.toml" ]]; then
    info "Writing Helix config"
    cat > "$HELIX_DIR/config.toml" << 'HELIX_CFG'
theme = "catppuccin_mocha"

[editor]
line-number = "relative"
cursorline = true
bufferline = "multiple"
color-modes = true
true-color = true
rulers = [100]
idle-timeout = 0
completion-timeout = 5
shell = ["zsh", "-c"]

[editor.cursor-shape]
insert = "bar"
normal = "block"
select = "underline"

[editor.lsp]
display-messages = true
display-inlay-hints = true

[editor.inline-diagnostics]
cursor-line = "hint"
other-lines = "error"

[editor.statusline]
left = ["mode", "spinner", "file-name", "file-modification-indicator"]
center = ["diagnostics"]
right = ["selections", "position", "file-encoding", "file-line-ending", "file-type", "version-control"]

[editor.indent-guides]
render = true
character = "│"
skip-levels = 1

[editor.soft-wrap]
enable = true

[editor.file-picker]
hidden = false
git-ignore = true

[keys.normal]
# Quick save
C-s = ":write"
# Buffer navigation
H = ":buffer-previous"
L = ":buffer-next"
# Close buffer
C-w = ":buffer-close"
# Open file picker with leader
# (Space+f is already default in helix)

[keys.normal.space]
# Markdown preview with glow in a zellij pane
m = ":sh md-preview %{buffer_name}"
HELIX_CFG
else
    warn "Helix config already exists, skipping"
fi

if [[ ! -f "$HELIX_DIR/languages.toml" ]]; then
    info "Writing Helix languages config"
    cat > "$HELIX_DIR/languages.toml" << 'HELIX_LANG'
# Codeium via helix-gpt — inline completions
[language-server.gpt]
command = "helix-gpt"
args = ["--handler", "codeium"]

# Rust — uses rust-analyzer (install via rustup component add rust-analyzer)
[[language]]
name = "rust"
auto-format = true
language-servers = ["rust-analyzer", "gpt"]

[language-server.rust-analyzer.config]
check.command = "clippy"

# Python — uses ruff + pyright
[[language]]
name = "python"
auto-format = true
language-servers = ["ruff", "pyright", "gpt"]

[language-server.ruff]
command = "ruff"
args = ["server"]

[language-server.pyright]
command = "pyright-langserver"
args = ["--stdio"]

# TypeScript
[[language]]
name = "typescript"
auto-format = true
language-servers = ["typescript-language-server", "gpt"]

[[language]]
name = "tsx"
auto-format = true
language-servers = ["typescript-language-server", "gpt"]

# TOML
[[language]]
name = "toml"
auto-format = true
language-servers = ["gpt"]

# YAML
[[language]]
name = "yaml"
auto-format = true
language-servers = ["gpt"]

# Bash
[[language]]
name = "bash"
auto-format = true
language-servers = ["gpt"]
HELIX_LANG
else
    warn "Helix languages config already exists, skipping"
fi
