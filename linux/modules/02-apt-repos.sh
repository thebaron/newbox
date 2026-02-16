#!/usr/bin/env bash
# 02-apt-repos.sh - Configure third-party apt repositories with GPG keys
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

log_section "APT Repositories"

repo_count=$(read_yaml_length '.apt_repos')

for i in $(seq 0 $((repo_count - 1))); do
    name=$(read_yaml_value ".apt_repos[$i].name")
    key_url=$(read_yaml_value ".apt_repos[$i].key_url")
    key_path=$(read_yaml_value ".apt_repos[$i].key_path")
    repo_line=$(read_yaml_value ".apt_repos[$i].repo")
    list_file=$(read_yaml_value ".apt_repos[$i].list_file")

    repo_line=$(template_replace "$repo_line")

    # Check if repo already configured
    if [[ -f "/etc/apt/sources.list.d/${list_file}" ]]; then
        log_skip "Repo $name (already configured)"
        continue
    fi

    log_info "Adding repo: $name"

    if [[ -n "$key_url" ]]; then
        if [[ "$key_url" == keyserver://* ]]; then
            # key_url format: keyserver://keyserver/0xkeyid
            keyserver_info="${key_url#keyserver://}"
            keyserver_host="${keyserver_info%%/*}"
            keyid="${keyserver_info##*/}"
            run_cmd bash -c "gpg --keyserver '$keyserver_host' --recv-keys '$keyid'"
            run_cmd bash -c "gpg --export '$keyid' | sudo gpg --dearmor --yes -o '$key_path'"
        else
            # Download and install GPG key via HTTP(s)
            run_cmd bash -c "curl -fsSL '$key_url' | sudo gpg --dearmor --yes -o '$key_path'"
        fi
    fi

    # Write sources list
    run_cmd bash -c "echo '$repo_line' | sudo tee /etc/apt/sources.list.d/${list_file} > /dev/null"

    # Run extra steps if defined
    extra_count=$(read_yaml_length ".apt_repos[$i].extra_steps // []")
    if [[ "$extra_count" != "0" && "$extra_count" != "null" ]]; then
        for j in $(seq 0 $((extra_count - 1))); do
            extra_cmd=$(read_yaml_value ".apt_repos[$i].extra_steps[$j]")
            log_info "  Running extra step: $extra_cmd"
            run_cmd bash -c "$extra_cmd"
        done
    fi

    log_ok "Added repo: $name"
done
