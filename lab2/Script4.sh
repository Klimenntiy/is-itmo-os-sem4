#!/bin/bash

> "$output_file"

for pid_path in /proc/[0-9]*; do
    pid=$(basename "$pid_path")

    if [[ "$pid" =~ ^[0-9]+$ ]]; then
        ppid=$(awk '/^PPid/ {print $2}' /proc/$pid/status)

        sum_exec_runtime=$(awk '/^sum_exec_runtime/ {print $2}' /proc/$pid/sched)
        nr_switches=$(awk '/^nr_switches/ {print $2}' /proc/$pid/sched)

        if [[ -n "$sum_exec_runtime" && -n "$nr_switches" && "$nr_switches" -gt 0 ]]; then
            art=$(echo "scale=6; $sum_exec_runtime / $nr_switches" | bc)
            echo "ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$art" >> "$output_file"
        fi
    fi
done

sort -t: -k2,2n "$output_file" -o "$output_file"
