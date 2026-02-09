#!/usr/bin/env bash
# 01-prerequisites.sh - Install base prerequisites (hardcoded, no YAML dependency)
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

log_section "Prerequisites"

# Hardcoded list - these are needed before yq/YAML parsing is available
PREREQS=(
    curl
    wget
    git
    gnupg
    apt-transport-https
    ca-certificates
    software-properties-common
    flatpak
    gnome-software-plugin-flatpak
    unzip
    build-essential
)

missing=()
for pkg in "${PREREQS[@]}"; do
    if is_apt_installed "$pkg"; then
        log_skip "$pkg (already installed)"
    else
        missing+=("$pkg")
    fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
    log_info "Installing ${#missing[@]} prerequisite packages..."
    run_cmd sudo apt-get update -qq
    run_cmd sudo apt-get install -y "${missing[@]}"
    for pkg in "${missing[@]}"; do
        log_ok "Installed $pkg"
    done
else
    log_info "All prerequisites already installed"
fi

# Add Flathub remote if not present
if ! flatpak remote-list 2>/dev/null | grep -q "flathub"; then
    log_info "Adding Flathub remote..."
    run_cmd sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    log_ok "Added Flathub remote"
else
    log_skip "Flathub remote (already configured)"
fi
