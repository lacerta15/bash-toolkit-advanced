#!/bin/bash
# Structured logging library
# Usage: source logger.sh; log_info "message"

LOG_LEVEL="${LOG_LEVEL:-INFO}"
LOG_FILE="${LOG_FILE:-/var/log/$(basename "$0" .sh).log}"
LOG_COLORS="${LOG_COLORS:-true}"

_log() {
    local level="$1"; shift
    local msg="$*"
    local ts; ts=$(date '+%Y-%m-%d %H:%M:%S')
    local line="[$ts] [$level] $msg"

    echo "$line" >> "$LOG_FILE"

    if [ "$LOG_COLORS" = "true" ]; then
        case "$level" in
            DEBUG) printf "\033[0;37m%s\033[0m\n" "$line" ;;
            INFO)  printf "\033[0;32m%s\033[0m\n" "$line" ;;
            WARN)  printf "\033[0;33m%s\033[0m\n" "$line" ;;
            ERROR) printf "\033[0;31m%s\033[0m\n" "$line" ;;
            *)     echo "$line" ;;
        esac
    else
        echo "$line"
    fi
}

log_debug() { [[ "$LOG_LEVEL" =~ ^(DEBUG)$ ]] && _log DEBUG "$@"; }
log_info()  { _log INFO  "$@"; }
log_warn()  { _log WARN  "$@"; }
log_error() { _log ERROR "$@"; }
