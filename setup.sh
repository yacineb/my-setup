#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Terminal-First Dev Environment Setup for macOS
# Stack: Ghostty + Zellij + Helix + Yazi + Lazygit + Starship + utilities
# =============================================================================

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
RESET='\033[0m'

info()  { echo -e "${GREEN}[+]${RESET} $1"; }
warn()  { echo -e "${YELLOW}[!]${RESET} $1"; }
err()   { echo -e "${RED}[x]${RESET} $1"; }
header(){ echo -e "\n${BOLD}=== $1 ===${RESET}\n"; }

# -----------------------------------------------------------------------------
# 1. Homebrew
# -----------------------------------------------------------------------------
header "Checking Homebrew"

if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    info "Homebrew already installed"
fi

# -----------------------------------------------------------------------------
# 2. Install packages
# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# 3. Ghostty config
# -----------------------------------------------------------------------------
header "Configuring Ghostty"

GHOSTTY_DIR="$HOME/.config/ghostty"
mkdir -p "$GHOSTTY_DIR"

if [[ ! -f "$GHOSTTY_DIR/config" ]]; then
    info "Writing Ghostty config"
    cat > "$GHOSTTY_DIR/config" << 'GHOSTTY'
# Font
font-family = JetBrains Mono
font-size = 14

# Theme — clean dark
theme = catppuccin-mocha

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

# -----------------------------------------------------------------------------
# 4. Helix config
# -----------------------------------------------------------------------------
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
HELIX_CFG
else
    warn "Helix config already exists, skipping"
fi

if [[ ! -f "$HELIX_DIR/languages.toml" ]]; then
    info "Writing Helix languages config"
    cat > "$HELIX_DIR/languages.toml" << 'HELIX_LANG'
# Rust — uses rust-analyzer (install via rustup component add rust-analyzer)
[[language]]
name = "rust"
auto-format = true

[language-server.rust-analyzer.config]
check.command = "clippy"
cargo.features = "all"

# Python — uses ruff + pyright
[[language]]
name = "python"
auto-format = true
language-servers = ["ruff", "pyright"]

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
language-servers = ["typescript-language-server"]

[[language]]
name = "tsx"
auto-format = true
language-servers = ["typescript-language-server"]

# TOML
[[language]]
name = "toml"
auto-format = true

# YAML
[[language]]
name = "yaml"
auto-format = true

# Bash
[[language]]
name = "bash"
auto-format = true
HELIX_LANG
else
    warn "Helix languages config already exists, skipping"
fi

# -----------------------------------------------------------------------------
# 5. Zellij config
# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# 6. Yazi config
# -----------------------------------------------------------------------------
header "Configuring Yazi"

YAZI_DIR="$HOME/.config/yazi"
mkdir -p "$YAZI_DIR"

if [[ ! -f "$YAZI_DIR/yazi.toml" ]]; then
    info "Writing Yazi config"
    cat > "$YAZI_DIR/yazi.toml" << 'YAZI_CFG'
[manager]
ratio = [1, 3, 4]
sort_by = "natural"
sort_dir_first = true
show_hidden = true
show_symlink = true

[opener]
edit = [
    { run = 'hx "$@"', block = true, for = "unix" },
]

[preview]
max_width = 1000
max_height = 1000
YAZI_CFG
else
    warn "Yazi config already exists, skipping"
fi

# -----------------------------------------------------------------------------
# 7. Lazygit config
# -----------------------------------------------------------------------------
header "Configuring Lazygit"

LAZYGIT_DIR="$HOME/Library/Application Support/lazygit"
mkdir -p "$LAZYGIT_DIR"

if [[ ! -f "$LAZYGIT_DIR/config.yml" ]]; then
    info "Writing Lazygit config"
    cat > "$LAZYGIT_DIR/config.yml" << 'LAZYGIT_CFG'
gui:
  showIcons: true
  nerdFontsVersion: "3"
  theme:
    activeBorderColor:
      - "#89b4fa"
      - bold
    inactiveBorderColor:
      - "#a6adc8"
    selectedLineBgColor:
      - "#313244"
git:
  paging:
    colorArg: always
    pager: delta --dark --paging=never
  log:
    showGraph: always
os:
  editPreset: "helix"
LAZYGIT_CFG
else
    warn "Lazygit config already exists, skipping"
fi

# -----------------------------------------------------------------------------
# 8. Starship prompt
# -----------------------------------------------------------------------------
header "Configuring Starship"

if [[ ! -f "$HOME/.config/starship.toml" ]]; then
    info "Writing Starship config"
    cat > "$HOME/.config/starship.toml" << 'STARSHIP_CFG'
format = """
$directory\
$git_branch\
$git_status\
$rust\
$python\
$nodejs\
$cmd_duration\
$line_break\
$character"""

[character]
success_symbol = "[>](bold green)"
error_symbol = "[>](bold red)"

[directory]
truncation_length = 3
truncation_symbol = ".../"

[git_branch]
symbol = " "
format = "[$symbol$branch]($style) "

[git_status]
format = '([$all_status$ahead_behind]($style) )'

[rust]
symbol = " "
format = "[$symbol($version)]($style) "

[python]
symbol = " "
format = "[$symbol($version)]($style) "

[nodejs]
symbol = " "
format = "[$symbol($version)]($style) "

[cmd_duration]
min_time = 2_000
format = "[$duration]($style) "
STARSHIP_CFG
else
    warn "Starship config already exists, skipping"
fi

# -----------------------------------------------------------------------------
# 9. Git delta config (global)
# -----------------------------------------------------------------------------
header "Configuring git-delta"

if ! git config --global core.pager &>/dev/null; then
    info "Setting delta as git pager"
    git config --global core.pager "delta"
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.side-by-side true
    git config --global delta.line-numbers true
    git config --global merge.conflictstyle "zdiff3"
else
    warn "Git pager already configured, skipping delta setup"
fi

# -----------------------------------------------------------------------------
# 10. Shell integration (.zshrc)
# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# 11. Install LSP servers for Helix
# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------
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
echo ""
info "Happy hacking!"
