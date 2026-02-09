#!/usr/bin/env bash
# 06-binaries.sh - Download and install versioned binaries
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

log_section "Binary Downloads"

bin_count=$(read_yaml_length '.binaries')

for i in $(seq 0 $((bin_count - 1))); do
    name=$(read_yaml_value ".binaries[$i].name")
    version=$(read_yaml_value ".binaries[$i].version")
    check_cmd=$(read_yaml_value ".binaries[$i].check_cmd")
    check_version_cmd=$(read_yaml_value ".binaries[$i].check_version_cmd // \"\"")
    url=$(read_yaml_value ".binaries[$i].url")
    archive_type=$(read_yaml_value ".binaries[$i].archive_type")
    install_method=$(read_yaml_value ".binaries[$i].install_method")
    install_path=$(read_yaml_value ".binaries[$i].install_path // \"\"")
    pre_install=$(read_yaml_value ".binaries[$i].pre_install // \"\"")
    installer_cmd=$(read_yaml_value ".binaries[$i].installer_cmd // \"\"")
    script_env=$(read_yaml_value ".binaries[$i].script_env // \"\"")
    post_install=$(read_yaml_value ".binaries[$i].post_install // \"\"")
    
    # Template substitution
    url=$(template_replace "$url" "$version")
    installer_cmd=$(template_replace "$installer_cmd" "$version")

    # Version check (skip if already installed with correct version)
    if is_installed "$check_cmd" && [[ "$version" != "latest" && -n "$check_version_cmd" ]]; then
        current_version=$(eval "$check_version_cmd" 2>/dev/null || echo "")
        if version_matches "$current_version" "$version"; then
            log_skip "$name v${version} (already installed)"
            continue
        fi
        log_info "$name: current=$current_version, want=$version"
    elif is_installed "$check_cmd" && [[ "$version" == "latest" ]]; then
        log_skip "$name (already installed, version=latest)"
        continue
    fi

    log_info "Installing $name${version:+ v${version}}..."

    # Download
    local_file="${TMP_DIR}/${name}-download"
    run_cmd curl -fsSL "$url" -o "$local_file"

    # Pre-install steps
    if [[ -n "$pre_install" && "$pre_install" != "null" ]]; then
        log_info "  Running pre-install: $pre_install"
        run_cmd bash -c "$pre_install"
    fi

    # Extract/install based on type
    case "$archive_type" in
        tar.gz)
            case "$install_method" in
                extract)
                    run_cmd sudo tar -C "$install_path" -xzf "$local_file"
                    ;;
                binary)
                    run_cmd tar -C "$TMP_DIR" -xzf "$local_file"
                    # Find the binary - it's the extracted file matching the name, or a single file
                    local_bin=$(find "$TMP_DIR" -maxdepth 1 -type f -executable -name "$name" 2>/dev/null | head -1)
                    if [[ -z "$local_bin" ]]; then
                        local_bin=$(find "$TMP_DIR" -maxdepth 1 -type f -name "$name" 2>/dev/null | head -1)
                    fi
                    if [[ -n "$local_bin" ]]; then
                        run_cmd sudo install "$local_bin" "$install_path"
                    else
                        warn_continue "Could not find $name binary after extraction"
                        continue
                    fi
                    ;;
            esac
            ;;
        zip)
            run_cmd unzip -o "$local_file" -d "$TMP_DIR"
            if [[ "$install_method" == "installer" && -n "$installer_cmd" ]]; then
                run_cmd bash -c "$installer_cmd"
            fi
            ;;
        binary)
            run_cmd sudo install "$local_file" "$install_path"
            ;;
        script)
            run_cmd sudo bash -c "${script_env:-} . $local_file"
            ;;
    esac

    # Post-install steps
    if [[ -n "$post_install" && "$post_install" != "null" ]]; then
        log_info "  Running post-install: $post_install"
        run_cmd bash -c "$post_install"
    fi

    log_ok "Installed $name${version:+ v${version}}"
done
