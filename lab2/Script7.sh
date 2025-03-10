#!/bin/bash

declare -A bytesRead

for pid in $(ls /proc | grep -E '^[0-9]+$'); do
	io_file="/proc/$pid/io"

	if [ -f "$io_file" ]; then
		bytes_read=$(grep "read_bytes" "$io_file" | awk '{print $2}')
		bytesRead["$pid"]=$bytes_read
	fi
done

sleep 60

for pid in $(ls /proc | grep -E '^[0-9]+$'); do
	io_file="/proc/$pid/io"

	if [ -f "$io_file" ]; then
		bytes_read=$(grep "read_bytes" "$io_file" | awk '{print $2}')
		current_bytes=${bytesRead["$pid"]}
		bytesRead["$pid"]=$((current_bytes - bytes_read))
	fi
done

sorted=($(for key in "${!bytesRead[@]}"; do
	echo "$key ${bytesRead[$key]}"
done | sort -rn -k2))

count=0
for entry in "${sorted[@]}"; do
	pid=$(echo $entry | awk '{print $1}')
	bytes_read=${bytesRead[$pid]}
	if [ ! -f "/proc/$pid/cmdline" ]; then
		continue
	fi
	cmdline=$(tr -d '\0' <"/proc/$pid/cmdline")

	if [ ! -z "$cmdline" ]; then
		echo "$pid:$cmdline:$bytes_read"
		((count++))
	fi

	if [ $count -eq 3 ]; then
		break
	fi
done