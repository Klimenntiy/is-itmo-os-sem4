#!/bin/bash

output_file="output.txt"
> "$output_file"

for pid_path in /proc/[0-9]*; do
    pid=$(basename "$pid_path")

    if [[ "$pid" =~ ^[0-9]+$ ]] && [[ -d /proc/$pid ]]; then
        if [[ -f /proc/$pid/status && -f /proc/$pid/sched ]]; then
            ppid=$(awk '/^PPid/ {print $2}' /proc/$pid/status)
            sum_exec_runtime=$(awk '/^sum_exec_runtime/ {print $2}' /proc/$pid/sched)
            nr_switches=$(awk '/^nr_switches/ {print $2}' /proc/$pid/sched)

            echo "PID=$pid, PPID=$ppid, sum_exec_runtime=$sum_exec_runtime, nr_switches=$nr_switches"  # Лог

            if [[ -n "$sum_exec_runtime" && -n "$nr_switches" && "$nr_switches" -gt 0 ]]; then
                art=$(echo "scale=6; $sum_exec_runtime / $nr_switches" | bc)
                echo "ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$art" >> "$output_file"
            fi
        fi
    fi
done

if [[ -s "$output_file" ]]; then
    sort -t: -k2,2n "$output_file" -o "$output_file"
else
    echo "No data to sort."
fi
