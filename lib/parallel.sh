#!/bin/bash
# Run commands in parallel with concurrency limit
# Usage: parallel_run 5 "cmd1" "cmd2" "cmd3"...
parallel_run() {
    local max_jobs="$1"; shift
    local pids=()

    for cmd in "$@"; do
        while [ "${#pids[@]}" -ge "$max_jobs" ]; do
            for i in "${!pids[@]}"; do
                if ! kill -0 "${pids[$i]}" 2>/dev/null; then
                    unset 'pids[$i]'
                fi
            done
            pids=("${pids[@]}")
            sleep 0.1
        done

        bash -c "$cmd" &
        pids+=($!)
    done

    for pid in "${pids[@]}"; do
        wait "$pid"
    done
}
