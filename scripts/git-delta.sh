#!/usr/bin/env bash
# Configure git-delta as global git pager

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
