#!/usr/bin/env bash
# lib/common.sh - Shared functions for newbox setup modules

set -euo pipefail

# ── Environment ──────────────────────────────────────────────────────────────

REPO_ROOT="${REPO_ROOT:-$(git rev-parse --show-toplevel)}"
CONFIG_FILE="${CONFIG_FILE:-${REPO_ROOT}/packages.yml}"
LOG_FILE="${LOG_FILE:-/tmp/newbox-setup-$(date +%Y%m%d-%H%M%S).log}"
CODENAME="${CODENAME:-$(lsb_release -cs 2>/dev/null || echo unknown)}"
ARCH="${ARCH:-$(dpkg --print-architecture 2>/dev/null || echo amd64)}"
TMP_DIR="${TMP_DIR:-$(mktemp -d /tmp/newbox-XXXXXX)}"
DRY_RUN="${DRY_RUN:-false}"

# Counters
INSTALLED_COUNT=0
SKIPPED_COUNT=0
FAILED_COUNT=0

# ── Logging ──────────────────────────────────────────────────────────────────

_RED='\033[0;31m'
_GREEN='\033[0;32m'
_YELLOW='\033[0;33m'
_BLUE='\033[0;34m'
_CYAN='\033[0;36m'
_BOLD='\033[1m'
_RESET='\033[0m'

_log() {
    local color="$1" label="$2" msg="$3"
    printf "${color}[%-4s]${_RESET} %s\n" "$label" "$msg"
    echo "[$(date '+%H:%M:%S')] [$label] $msg" >> "$LOG_FILE"
}

log_info()    { _log "$_BLUE"   "INFO" "$*"; }
log_warn()    { _log "$_YELLOW" "WARN" "$*"; }
log_error()   { _log "$_RED"    "ERR " "$*"; }
log_skip()    { _log "$_CYAN"   "SKIP" "$*"; SKIPPED_COUNT=$((SKIPPED_COUNT + 1)); }
log_ok()      { _log "$_GREEN"  "OK  " "$*"; INSTALLED_COUNT=$((INSTALLED_COUNT + 1)); }
log_section() { printf "\n${_BOLD}${_BLUE}═══ %s ═══${_RESET}\n\n" "$*"; echo "" >> "$LOG_FILE"; echo "=== $* ===" >> "$LOG_FILE"; }

# ── Error handling ───────────────────────────────────────────────────────────

abort() {
    log_error "$*"
    exit 1
}

warn_continue() {
    log_warn "$*"
    FAILED_COUNT=$((FAILED_COUNT + 1))
}

# ── Idempotency checks ──────────────────────────────────────────────────────

is_installed() {
    command -v "$1" &>/dev/null
}

is_apt_installed() {
    dpkg -s "$1" &>/dev/null 2>&1
}

is_flatpak_installed() {
    flatpak list --app --columns=application 2>/dev/null | grep -q "^${1}$"
}

is_snap_installed() {
    snap list "$1" &>/dev/null 2>&1
}

version_matches() {
    local current="$1" expected="$2"
    [[ "$current" == "$expected" ]]
}

# ── YAML helpers (require yq) ───────────────────────────────────────────────

read_yaml_list() {
    local path="$1"
    yq eval "$path | .[]" "$CONFIG_FILE" 2>/dev/null
}

read_yaml_value() {
    local path="$1"
    yq eval "$path" "$CONFIG_FILE" 2>/dev/null
}

read_yaml_length() {
    local path="$1"
    yq eval "$path | length" "$CONFIG_FILE" 2>/dev/null
}

template_replace() {
    local str="$1"
    str="${str//\{\{ version \}\}/${2:-}}"
    str="${str//\{\{ codename \}\}/${CODENAME}}"
    str="${str//\{\{ home \}\}/${HOME}}"
    str="${str//\{\{ repo_root \}\}/${REPO_ROOT}}"
    str="${str//\{\{ arch \}\}/${ARCH}}"
    str="${str//\{\{ tmp_dir \}\}/${TMP_DIR}}"
    echo "$str"
}

# ── Dry-run wrapper ─────────────────────────────────────────────────────────

run_cmd() {
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY-RUN] $*"
        return 0
    fi
    "$@"
}

# ── Cleanup & counter persistence ───────────────────────────────────────────

_write_counters() {
    if [[ -n "${COUNTER_FILE:-}" ]]; then
        cat > "$COUNTER_FILE" <<EOF
MODULE_INSTALLED=$INSTALLED_COUNT
MODULE_SKIPPED=$SKIPPED_COUNT
MODULE_FAILED=$FAILED_COUNT
EOF
    fi
}

_cleanup() {
    _write_counters
    # Only clean up TMP_DIR if we created it (not when run from setup.sh)
    if [[ -z "${COUNTER_FILE:-}" ]]; then
        rm -rf "$TMP_DIR" 2>/dev/null || true
    fi
}

trap _cleanup EXIT
