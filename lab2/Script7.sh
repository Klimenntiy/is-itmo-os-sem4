#!/bin/bash

echo "Collecting disk read statistics for 1 minute..."

declare -A start_reads

for pid in /proc/[0-9]*; do
    pid=$(basename "$pid")
    if [[ -r "/proc/$pid/io" ]]; then
        read_bytes=$(awk '/^read_bytes/ {print $2}' "/proc/$pid/io")
        start_reads[$pid]=$read_bytes
    fi
done

sleep 60

declare -A read_diffs

for pid in "${!start_reads[@]}"; do
    if [[ -r "/proc/$pid/io" && -r "/proc/$pid/cmdline" ]]; then
        end_read=$(awk '/^read_bytes/ {print $2}' "/proc/$pid/io")
        start_read=${start_reads[$pid]}
        read_diff=$((end_read - start_read))

        if [[ "$read_diff" -gt 0 ]]; then
            cmdline=$(tr '\0' ' ' < "/proc/$pid/cmdline")
            [[ -z "$cmdline" ]] && cmdline="[Unknown Command]"
            read_diffs["$pid"]="$read_diff:$cmdline"
        fi
    fi
done

if [[ ${#read_diffs[@]} -eq 0 ]]; then
    echo "No processes performed significant disk reads."
    exit 0
fi

printf "%s\n" "${!read_diffs[@]}" | while read -r pid; do
    echo "$pid:${read_diffs[$pid]}"
done | sort -t: -k2,2nr | head -n 3
