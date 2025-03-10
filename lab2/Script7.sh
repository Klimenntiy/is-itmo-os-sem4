#!/bin/bash


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
            read_diffs["$pid"]="$read_diff:$cmdline"
        fi
    fi
done

echo -e "\nTop 3 processes by disk read (bytes read in 1 minute):"
for entry in $(printf "%s\n" "${!read_diffs[@]}" | awk -F: '{print $1}' | xargs -I {} echo "{}:${read_diffs[{}]}" | sort -t: -k2,2nr | head -n 3); do
    echo "$entry"
done
