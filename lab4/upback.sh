#!/usr/bin/bash

backup_root_dir="$(dirname "$(realpath "$0")")"
destination_dir="$backup_root_dir/restore"

dirs=$(ls -d "$backup_root_dir"/Backup-* 2>/dev/null | sort -r)
latest_dir=$(echo "$dirs" | head -n 1)

if [ -z "$latest_dir" ]; then
    echo "[ERROR] No backup directories found"
    exit 1
fi

mkdir -p "$destination_dir"

echo "[INFO] Restoring files from backup: $latest_dir"

find "$latest_dir" -type f ! -regex '.*[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}.*' -exec cp {} "$destination_dir" \;

echo "[INFO] Restore completed from backup: $latest_dir"