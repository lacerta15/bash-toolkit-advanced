#!/bin/bash
# Retry wrapper with exponential backoff
# Usage: retry 3 5 my_command args...
retry() {
    local retries="$1"; shift
    local delay="$1"; shift
    local attempt=0

    while true; do
        attempt=$((attempt + 1))
        "$@" && return 0

        if [ "$attempt" -ge "$retries" ]; then
            echo "[retry] Command failed after $retries attempts: $*" >&2
            return 1
        fi

        echo "[retry] Attempt $attempt/$retries failed. Retrying in ${delay}s..." >&2
        sleep "$delay"
        delay=$((delay * 2))
    done
}
