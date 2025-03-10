#!/bin/bash

output_file="output.txt"
> "$output_file"

declare -A art_sums
declare -A art_counts
declare -A art_lines

for pid in $(ls /proc | grep -E '^[0-9]+$'); do
    if [[ -f "/proc/$pid/stat" ]]; then
        ppid=$(awk '{print $4}' /proc/$pid/stat)
        utime=$(awk '{print $14}' /proc/$pid/stat)
        stime=$(awk '{print $15}' /proc/$pid/stat)
        switches=$(awk '{print $40}' /proc/$pid/stat)

        total_time=$((utime + stime))

        if [[ "$switches" -gt 0 ]]; then
            art=$(echo "scale=6; $total_time / $switches" | bc)
            line="ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$art"
            art_lines["$ppid"]+="$line"$'\n'
            art_sums["$ppid"]=$(echo "${art_sums[$ppid]} + $art" | bc) 
            art_counts["$ppid"]=$((art_counts["$ppid"] + 1))
        fi
    fi
done

for ppid in "${!art_sums[@]}"; do
    if [[ ${art_counts[$ppid]} -gt 0 ]]; then
        avg_art=$(echo "scale=6; ${art_sums[$ppid]} / ${art_counts[$ppid]}" | bc)
        echo "Average_Running_Children_of_ParentID=$ppid is $avg_art" >> "$output_file"
        echo -e "${art_lines[$ppid]}" >> "$output_file"
    fi
done

if [[ -s "$output_file" ]]; then
    sort -t: -k2,2n "$output_file" -o "$output_file"
else
    echo "No data to sort."
fi
