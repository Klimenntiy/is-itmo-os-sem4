#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
RESTORE_DIR="$SCRIPT_DIR/restore"
BACKUP_ROOT="$SCRIPT_DIR"
LATEST_BACKUP=""

for dir in "$BACKUP_ROOT"/Backup-*; do
    [ -d "$dir" ] || continue
    DATE_PART=${dir##*-}
    if [[ $DATE_PART =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        if [ -z "$LATEST_BACKUP" ] || [ "$dir" \> "$LATEST_BACKUP" ]; then
            LATEST_BACKUP="$dir"
        fi
    fi
done

if [ -z "$LATEST_BACKUP" ]; then
    echo "[ERROR] No backup found."
    exit 1
fi

if [ ! -d "$RESTORE_DIR" ]; then
    mkdir "$RESTORE_DIR"
    echo "[INFO] Created restore directory: $RESTORE_DIR"
fi

for FILE in "$LATEST_BACKUP"/*; do
    BASENAME=$(basename "$FILE")
    
    if [[ ! "$BASENAME" =~ \.[0-9]{4}-[0-9]{2}-[0-9]{2}\.[0-9]+$ ]]; then
        cp "$FILE" "$RESTORE_DIR/"
        echo "[INFO] Copied file: $FILE to $RESTORE_DIR/"
    else
        echo "[INFO] Skipped file with version: $FILE"
    fi
done

echo "[INFO] Files copied to $RESTORE_DIR."
