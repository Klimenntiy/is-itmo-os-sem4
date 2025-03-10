#!/bin/bash

output_file="output.txt"
> "$output_file"

declare -A process_data
declare -A ppid_counts
declare -A ppid_sum_arts

for pid_path in /proc/[0-9]*; do
    pid=$(basename "$pid_path")

    if [[ "$pid" =~ ^[0-9]+$ ]] && [[ -d "/proc/$pid" ]]; then
        if [[ -f "/proc/$pid/status" && -f "/proc/$pid/sched" ]]; then
            ppid=$(awk '/^PPid/ {print $2}' "/proc/$pid/status")
            sum_exec_runtime=$(awk '/^sum_exec_runtime/ {print $2}' "/proc/$pid/sched")
            nr_switches=$(awk '/^nr_switches/ {print $2}' "/proc/$pid/sched")

            if [[ -n "$sum_exec_runtime" && -n "$nr_switches" && "$nr_switches" -gt 0 ]]; then
                art=$(echo "scale=6; $sum_exec_runtime / $nr_switches" | bc)
                process_data["$ppid"]+="$pid $art"$'\n'
                ppid_sum_arts["$ppid"]=$(echo "${ppid_sum_arts[$ppid]} + $art" | bc)
                ppid_counts["$ppid"]=$((ppid_counts["$ppid"] + 1))
            fi
        fi
    fi
done

for ppid in "${!process_data[@]}"; do
    echo -e "${process_data[$ppid]}" | sort -t: -k2,2n >> "$output_file"

    if [[ ${ppid_counts["$ppid"]} -gt 0 ]]; then
        avg_art=$(echo "${ppid_sum_arts[$ppid]} / ${ppid_counts[$ppid]}" | bc -l)
        echo "Average_Running_Children_of_ParentID=$ppid is $avg_art" >> "$output_file"
    fi
done

if [[ ! -s "$output_file" ]]; then
    echo "No data to sort."
fi
