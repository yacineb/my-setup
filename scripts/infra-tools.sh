#!/usr/bin/env bash
# Install infrastructure / Kubernetes tools

header "Installing infra tools"

# --- k9s: TUI for Kubernetes clusters ---
if command -v k9s &>/dev/null; then
    warn "k9s already installed ($(k9s version --short 2>/dev/null || echo 'unknown'))"
else
    info "Installing k9s"
    brew install derailed/k9s/k9s
fi

# --- krew: kubectl plugin manager ---
if kubectl krew version &>/dev/null 2>&1; then
    warn "krew already installed"
else
    info "Installing krew"
    brew install krew
fi

# Add krew to PATH for the rest of this script
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# --- kubectl plugins for cluster hygiene ---
KREW_PLUGINS=(
    popeye              # cluster sanitizer — flags misconfigs and best-practice violations
    kor                 # find unused/orphaned resources
    deprecations        # detect deprecated APIs before upgrades
    resource-capacity   # show resource requests, limits, and utilization
    who-can             # reverse RBAC lookup for security audits
)

for plugin in "${KREW_PLUGINS[@]}"; do
    if kubectl krew list 2>/dev/null | grep -q "^${plugin}$"; then
        warn "kubectl plugin '${plugin}' already installed"
    else
        info "Installing kubectl plugin '${plugin}'"
        kubectl krew install "$plugin"
    fi
done
