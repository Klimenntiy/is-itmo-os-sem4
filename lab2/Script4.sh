#!/bin/bash

output_file="process_info.txt"

> "$output_file"

for pid in /proc/[0-9]*; do
    pid=$(basename "$pid")

    if [[ "$pid" =~ ^[0-9]+$ ]]; then
        ppid=$(grep -i "^PPid" /proc/$pid/status | awk '{print $2}')

        sum_exec_runtime=$(grep -i "^sum_exec_runtime" /proc/$pid/sched | awk '{print $2}')
        nr_switches=$(grep -i "^nr_switches" /proc/$pid/sched | awk '{print $2}')

        if [[ -n "$sum_exec_runtime" && -n "$nr_switches" && "$nr_switches" -gt 0 ]]; then
            art=$(echo "$sum_exec_runtime / $nr_switches" | bc -l)
            echo "ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$art" >> "$output_file"
        fi
    fi
done

sort -t: -k2,2n "$output_file" -o "$output_file"
