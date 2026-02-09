#!/usr/bin/env bash
# setup.sh - Main orchestrator for newbox Linux setup
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── CLI argument parsing ─────────────────────────────────────────────────────

MODE="all"
DRY_RUN="false"
SKIP_MODULES=()
CONFIG_FILE="${SCRIPT_DIR}/packages.yml"
TARGET_MODULE=""

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  --all             Run all modules (default)
  --module NAME     Run only the specified module (e.g. "flatpak", "binaries")
  --skip MODULE     Skip a module (can be repeated)
  --dry-run         Show what would be done without making changes
  --config PATH     Use alternate config file (default: packages.yml)
  --help            Show this help message

Modules: prerequisites, apt-repos, apt-packages, flatpak, snaps, binaries,
         fonts, gnome-terminal, gnome-extensions, dotfiles
EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --all)        MODE="all"; shift ;;
        --module)     MODE="single"; TARGET_MODULE="$2"; shift 2 ;;
        --skip)       SKIP_MODULES+=("$2"); shift 2 ;;
        --dry-run)    DRY_RUN="true"; shift ;;
        --config)     CONFIG_FILE="$2"; shift 2 ;;
        --help|-h)    usage ;;
        *)            echo "Unknown option: $1"; usage ;;
    esac
done

export DRY_RUN CONFIG_FILE

# ── Preflight checks ────────────────────────────────────────────────────────

if [[ $EUID -eq 0 ]]; then
    echo "ERROR: Do not run as root. This script uses sudo internally."
    exit 1
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "ERROR: Config file not found: $CONFIG_FILE"
    exit 1
fi

# ── Logging setup ────────────────────────────────────────────────────────────

export LOG_FILE="/tmp/newbox-setup-$(date +%Y%m%d-%H%M%S).log"
touch "$LOG_FILE"

# Source common library
source "${SCRIPT_DIR}/lib/common.sh"

export TMP_DIR CODENAME ARCH REPO_ROOT

log_section "Newbox Linux Setup"
log_info "Config: $CONFIG_FILE"
log_info "Log file: $LOG_FILE"
log_info "Dry run: $DRY_RUN"
log_info "Codename: $CODENAME"

# ── Bootstrap yq ─────────────────────────────────────────────────────────────

YQ_VERSION="4.44.6"
if ! is_installed yq || ! yq --version 2>/dev/null | grep -q "$YQ_VERSION"; then
    log_info "Bootstrapping yq v${YQ_VERSION} (required for config parsing)..."
    curl -fsSL "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64" -o "${TMP_DIR}/yq"
    sudo install "${TMP_DIR}/yq" /usr/local/bin/yq
fi

# Validate config parses
if is_installed yq; then
    if ! yq eval '.prerequisites' "$CONFIG_FILE" &>/dev/null; then
        abort "Failed to parse config file: $CONFIG_FILE"
    fi
elif [[ "$DRY_RUN" != "true" ]]; then
    abort "yq is required but not available"
fi

# ── Module runner ────────────────────────────────────────────────────────────

TOTAL_INSTALLED=0
TOTAL_SKIPPED=0
TOTAL_FAILED=0

run_module() {
    local name="$1" script="$2" criticality="$3"

    # Check if module is skipped
    for skip in "${SKIP_MODULES[@]+"${SKIP_MODULES[@]}"}"; do
        if [[ "$skip" == "$name" ]]; then
            log_info "Skipping module: $name (--skip)"
            return 0
        fi
    done

    # In single-module mode, skip non-matching modules
    if [[ "$MODE" == "single" && "$TARGET_MODULE" != "$name" ]]; then
        return 0
    fi

    log_section "Module: $name"

    if [[ ! -f "$script" ]]; then
        if [[ "$criticality" == "critical" ]]; then
            abort "Critical module not found: $script"
        else
            warn_continue "Module not found: $script"
            return 0
        fi
    fi

    local counter_file="${TMP_DIR}/counters-${name}"
    export COUNTER_FILE="$counter_file"

    if bash "$script"; then
        # Read counters from module
        local mod_installed=0 mod_skipped=0 mod_failed=0
        if [[ -f "$counter_file" ]]; then
            source "$counter_file"
            mod_installed="${MODULE_INSTALLED:-0}"
            mod_skipped="${MODULE_SKIPPED:-0}"
            mod_failed="${MODULE_FAILED:-0}"
        fi
        log_info "Module $name completed (installed: $mod_installed, skipped: $mod_skipped, failed: $mod_failed)"
        TOTAL_INSTALLED=$((TOTAL_INSTALLED + mod_installed))
        TOTAL_SKIPPED=$((TOTAL_SKIPPED + mod_skipped))
        TOTAL_FAILED=$((TOTAL_FAILED + mod_failed))
    else
        if [[ "$criticality" == "critical" ]]; then
            abort "Critical module failed: $name"
        else
            warn_continue "Module failed: $name (non-critical, continuing)"
            TOTAL_FAILED=$((TOTAL_FAILED + 1))
        fi
    fi
}

# ── Execute modules in order ────────────────────────────────────────────────

run_module "prerequisites"     "${SCRIPT_DIR}/modules/01-prerequisites.sh"    critical
run_module "apt-repos"         "${SCRIPT_DIR}/modules/02-apt-repos.sh"        critical

# Run apt update between repos and packages
if [[ "$MODE" == "all" || "$TARGET_MODULE" == "apt-packages" ]]; then
    log_info "Running apt-get update..."
    run_cmd sudo apt update -qq
fi

run_module "apt-packages"      "${SCRIPT_DIR}/modules/03-apt-packages.sh"     critical
run_module "flatpak"           "${SCRIPT_DIR}/modules/04-flatpak.sh"          noncritical
run_module "snaps"             "${SCRIPT_DIR}/modules/05-snaps.sh"            noncritical
run_module "binaries"          "${SCRIPT_DIR}/modules/06-binaries.sh"         noncritical
run_module "fonts"             "${SCRIPT_DIR}/modules/07-fonts.sh"            noncritical
run_module "gnome-extensions"  "${SCRIPT_DIR}/modules/08-gnome-extensions.sh" noncritical
run_module "dotfiles"          "${SCRIPT_DIR}/modules/09-dotfiles.sh"         noncritical
run_module "rando"             "${SCRIPT_DIR}/modules/10-rando.sh"         noncritical

# ── Summary ──────────────────────────────────────────────────────────────────

echo ""
printf "${_BOLD}${_GREEN}═══ Setup Complete ═══${_RESET}\n"
printf "  Installed: ${_GREEN}%d${_RESET}\n" "$TOTAL_INSTALLED"
printf "  Skipped:   ${_CYAN}%d${_RESET}\n" "$TOTAL_SKIPPED"
printf "  Failed:    ${_RED}%d${_RESET}\n" "$TOTAL_FAILED"
printf "  Log file:  %s\n" "$LOG_FILE"
echo ""

if [[ $TOTAL_FAILED -gt 0 ]]; then
    exit 1
fi
