#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
RESTORE_DIR="$SCRIPT_DIR/restore"
BACKUP_ROOT="$SCRIPT_DIR"
TODAY=$(date +%F)

echo "[INFO] Current date: $TODAY"
echo "[INFO] Searching for backups in: $BACKUP_ROOT"

BACKUP_DIRS=$(ls -d "$BACKUP_ROOT"/Backup-* 2>/dev/null)
if [ -z "$BACKUP_DIRS" ]; then
    echo "[ERROR] No Backup-* directories found."
    exit 1
else
    echo "[INFO] Found backup directories:"
    echo "$BACKUP_DIRS"
fi

LATEST_BACKUP=""
LATEST_DATE=0

for dir in $BACKUP_DIRS; do
    [ -d "$dir" ] || continue
    BASENAME=$(basename "$dir")
    DATE_PART=${BASENAME#Backup-}

    if [[ $DATE_PART =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        BACKUP_DATE=$(date -d "$DATE_PART" +%s 2>/dev/null)
        if [ -z "$BACKUP_DATE" ]; then
            echo "[WARNING] Failed to parse date in directory: $dir"
            continue
        fi

        CURRENT_DATE=$(date +%s)
        DIFF_DAYS=$(( (CURRENT_DATE - BACKUP_DATE) / 86400 ))

        echo "[DEBUG] Checking: $dir | Date: $DATE_PART | Days difference: $DIFF_DAYS"

        if [ "$DIFF_DAYS" -lt 7 ] && [ "$BACKUP_DATE" -gt "$LATEST_DATE" ]; then
            LATEST_BACKUP="$dir"
            LATEST_DATE=$BACKUP_DATE
        fi
    else
        echo "[WARNING] Directory name doesn't contain valid date: $dir"
    fi
done

if [ -z "$LATEST_BACKUP" ]; then
    echo "[ERROR] No suitable backups found from the last 7 days."
    exit 1
else
    echo "[INFO] Found recent backup: $LATEST_BACKUP"
fi

mkdir -p "$RESTORE_DIR"
echo "[INFO] Restore directory: $RESTORE_DIR"

RESTORED_COUNT=0
for FILE in "$LATEST_BACKUP"/*; do
    [ -f "$FILE" ] || continue
    BASENAME=$(basename "$FILE")

    if [[ "$BASENAME" =~ \.[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "[SKIP] Skipping versioned file: $BASENAME"
        continue
    fi

    if [ -f "$RESTORE_DIR/$BASENAME" ]; then
        echo "[SKIP] File already exists in restore/: $BASENAME"
    else
        cp "$FILE" "$RESTORE_DIR/$BASENAME"
        echo "[RESTORED] Restored: $BASENAME"
        ((RESTORED_COUNT++))
    fi
done

echo "[DONE] Restoration complete. Total files restored: $RESTORED_COUNT"