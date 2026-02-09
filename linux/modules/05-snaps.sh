#!/usr/bin/env bash
# 05-snaps.sh - Install snap packages
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

log_section "Snap Packages"

snap_count=$(read_yaml_length '.snap_packages')

for i in $(seq 0 $((snap_count - 1))); do
    name=$(read_yaml_value ".snap_packages[$i].name")
    classic=$(read_yaml_value ".snap_packages[$i].classic")

    if is_snap_installed "$name"; then
        log_skip "$name (already installed)"
        continue
    fi

    log_info "Installing snap: $name..."
    local_args=()
    if [[ "$classic" == "true" ]]; then
        local_args+=(--classic)
    fi

    if [[ -n "$name" && "$name" != "null" ]]; then 
        if run_cmd sudo snap install "$name" "${local_args[@]}"; then
            log_ok "Installed snap: $name"
        else
            warn_continue "Failed to install snap: $name"
        fi
    fi
done
