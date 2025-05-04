#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
RESTORE_DIR="$SCRIPT_DIR/restore"  
BACKUP_ROOT="$SCRIPT_DIR" 
TODAY=$(date +%F)

LATEST_BACKUP=""
for dir in "$BACKUP_ROOT"/Backup-*; do
    [ -d "$dir" ] || continue
    DATE_PART=${dir##*-} 
    if [[ $DATE_PART =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        DIFF=$(( ($(date +%s) - $(date -d "$DATE_PART" +%s)) / 86400 )) 
        if [ "$DIFF" -lt 7 ]; then
            LATEST_BACKUP="$dir"  
            break
        fi
    fi
done

if [ -z "$LATEST_BACKUP" ]; then
    echo "No recent backup found within the last 7 days."
    exit 1
else
    echo "Latest backup found: $LATEST_BACKUP"
    
    if [ ! -d "$RESTORE_DIR" ]; then
        mkdir "$RESTORE_DIR"
        echo "Created restore directory."
    fi

    for FILE in "$LATEST_BACKUP"/*; do
        BASENAME=$(basename "$FILE")

        if [[ "$BASENAME" =~ \.[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
            continue
        fi

        cp "$FILE" "$RESTORE_DIR/$BASENAME"
        echo "Restored: $BASENAME"
    done
    echo "Restore completed."
fi
