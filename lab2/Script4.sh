#!/bin/bash

output_file="output.txt"
> "$output_file"

for pid in $(ls /proc | grep -E '^[0-9]+$'); do
    if [[ -f "/proc/$pid/stat" ]]; then
        ppid=$(awk '{print $4}' /proc/$pid/stat)
        utime=$(awk '{print $14}' /proc/$pid/stat)
        stime=$(awk '{print $15}' /proc/$pid/stat)
        switches=$(awk '{print $40}' /proc/$pid/stat)

        total_time=$((utime + stime))

        if [[ "$switches" -gt 0 ]]; then
            art=$(echo "scale=6; $total_time / $switches" | bc)
            echo "ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$art" >> "$output_file"
        fi
    fi
done

if [[ -s "$output_file" ]]; then
    sort -t: -k2,2n "$output_file" -o "$output_file"
else
    echo "No data to sort."
fi
