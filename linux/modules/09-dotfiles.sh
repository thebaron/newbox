#!/usr/bin/env bash
# 09-dotfiles.sh - Symlink dotfiles from repo to home directory
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

log_section "Dotfiles"

source_dir=$(read_yaml_value '.dotfiles.source_dir')
target_dir=$(read_yaml_value '.dotfiles.target_dir')
source_dir=$(template_replace "$source_dir")
target_dir=$(template_replace "$target_dir")

if [[ ! -d "$source_dir" ]]; then
    log_info "Dotfiles source directory not found: $source_dir"
    log_info "Create $source_dir with your dotfiles to enable this module"
    exit 0
fi

cd $source_dir && find . | cpio -dpvm $target_dir
log_ok "Dotfiles copied $source_dir -> $target_dir"
