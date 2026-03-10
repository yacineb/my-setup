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

git config --global core.pager delta

# Configure ec as merge tool (terminal 3-way merge, IntelliJ-style)
header "Configuring merge tool (ec)"

if ! git config --global merge.tool &>/dev/null; then
    info "Setting ec as merge tool"
    git config --global merge.tool "ec"
    git config --global mergetool.keepBackup false
    git config --global mergetool.ec.cmd 'ec "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
    git config --global mergetool.ec.trustExitCode true
else
    warn "Merge tool already configured, skipping"
fi
