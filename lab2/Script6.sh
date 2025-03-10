#!/bin/bash

echo "Finding process with the highest memory usage..."

maxMem=0
maxPid=0
maxName=""

for pid in /proc/[0-9]*; do
    pid=$(basename "$pid")

    if [[ -f "/proc/$pid/status" ]]; then
        memory=$(awk '/^VmRSS:/ {print $2}' "/proc/$pid/status")
        name=$(awk '/^Name:/ {print $2}' "/proc/$pid/status")

        if [[ -n "$memory" && "$memory" -gt "$maxMem" ]]; then
            maxMem=$memory
            maxPid=$pid
            maxName=$name
        fi
    fi
done

if [[ "$maxPid" -ne 0 ]]; then
    echo "Process with highest memory usage (from /proc):"
    echo "PID: $maxPid"
    echo "Name: $maxName"
    echo "VmRSS: ${maxMem} KB"
else
    echo "No valid process found."
fi

echo -e "\nTop processes by memory usage (from top command):"
top -b -o +%MEM | head -n 15
