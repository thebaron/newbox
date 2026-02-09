#!/usr/bin/env bash
# 08-gnome-extensions.sh - Install GNOME shell extensions
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

log_section "GNOME Shell Extensions"

if ! is_installed gnome-shell; then
    log_info "GNOME Shell not found, skipping extensions"
    exit 0
fi

gnome_version=$(gnome-shell --version 2>/dev/null | grep -oP '\d+' | head -1)
if [[ -z "$gnome_version" ]]; then
    warn_continue "Could not determine GNOME Shell version"
    exit 0
fi

log_info "GNOME Shell version: $gnome_version"

ext_count=$(read_yaml_length '.gnome_extensions')
ext_dir="${HOME}/.local/share/gnome-shell/extensions"
mkdir -p "$ext_dir"

for i in $(seq 0 $((ext_count - 1))); do
    uuid=$(read_yaml_value ".gnome_extensions[$i].uuid")
    name=$(read_yaml_value ".gnome_extensions[$i].name")

    if [[ -d "${ext_dir}/${uuid}" ]]; then
        log_skip "$name ($uuid already installed)"
        continue
    fi

    log_info "Installing extension: $name ($uuid)..."

    # Query extensions.gnome.org for download info
    info_url="https://extensions.gnome.org/extension-info/?uuid=${uuid}&shell_version=${gnome_version}"
    info_json=$(curl -fsSL "$info_url" 2>/dev/null || echo "")

    if [[ -z "$info_json" || "$info_json" == *"error"* ]]; then
        warn_continue "Could not fetch info for $name (may not support GNOME $gnome_version)"
        continue
    fi

    download_url=$(echo "$info_json" | yq eval '.download_url // ""' - 2>/dev/null)
    if [[ -z "$download_url" || "$download_url" == "null" ]]; then
        warn_continue "No download URL for $name"
        continue
    fi

    # Download and install
    ext_zip="${TMP_DIR}/${uuid}.zip"
    if run_cmd curl -fsSL "https://extensions.gnome.org${download_url}" -o "$ext_zip"; then
        run_cmd mkdir -p "${ext_dir}/${uuid}"
        run_cmd unzip -o "$ext_zip" -d "${ext_dir}/${uuid}"

        # Enable the extension
        run_cmd gnome-extensions enable "$uuid" 2>/dev/null || true
        log_ok "Installed extension: $name"
    else
        warn_continue "Failed to download extension: $name"
    fi
done
