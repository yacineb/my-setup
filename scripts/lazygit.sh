#!/usr/bin/env bash
# Configure Lazygit

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
  edit: "hx -- {{filename}}"
  editAtLine: "hx -- {{filename}}:{{line}}"
  editAtLineAndWait: "hx -- {{filename}}:{{line}}"
  openDirInEditor: "hx -- {{dir}}"
customCommands:
  - key: "C"
    context: "files"
    command: "gitmoji -c"
    description: "Commit with gitmoji"
    output: terminal
  - key: "M"
    context: "files"
    command: "git mergetool --no-prompt -- {{.SelectedFile.Name}}"
    description: "Resolve conflicts with ec"
    output: terminal
LAZYGIT_CFG
else
    warn "Lazygit config already exists, skipping"
fi
