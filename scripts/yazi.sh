#!/usr/bin/env bash
# Configure Yazi file manager

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
