#!/usr/bin/env bash
# 03-apt-packages.sh - Install apt packages from YAML config
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

log_section "APT Packages"

missing=()

while IFS= read -r pkg; do
    [[ -z "$pkg" ]] && continue
    if is_apt_installed "$pkg"; then
        log_skip "$pkg (already installed)"
    else
        missing+=("$pkg")
    fi
done < <(read_yaml_list '.apt_packages')

if [[ ${#missing[@]} -gt 0 ]]; then
    log_info "Installing ${#missing[@]} packages: ${missing[*]}"
    run_cmd sudo apt-get install -y "${missing[@]}"
    for pkg in "${missing[@]}"; do
        log_ok "Installed $pkg"
    done
else
    log_info "All apt packages already installed"
fi
