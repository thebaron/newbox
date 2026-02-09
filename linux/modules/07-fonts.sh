#!/usr/bin/env bash
# 07-fonts.sh - Install fonts from archives
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

log_section "Fonts"

target_dir="${HOME}/.local/share/fonts"
mkdir -p "$target_dir"


for font in $(ls ../fonts*.zip); do
    unzip -o -d $target_dir $font
done

fc-cache -fv $target_dir