#!/usr/bin/env bash
# 04-flatpak.sh - Install Flatpak applications from Flathub
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

log_section "Flatpak Apps"

app_count=$(read_yaml_length '.flatpak_apps')

for i in $(seq 0 $((app_count - 1))); do
    remote=$(read_yaml_value ".flatpak_apps[$i].remote")
    app_id=$(read_yaml_value ".flatpak_apps[$i].id")
    name=$(read_yaml_value ".flatpak_apps[$i].name")

    if is_flatpak_installed "$app_id"; then
        log_skip "$name ($app_id already installed)"
        continue
    fi

    log_info "Installing $name ($app_id)..."
    if run_cmd flatpak install -y "$remote" "$app_id"; then
        log_ok "Installed $name"
    else
        warn_continue "Failed to install $name ($app_id)"
    fi
done
