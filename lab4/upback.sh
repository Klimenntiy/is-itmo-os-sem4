#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"   
RESTORE_DIR="$SCRIPT_DIR/restore"            
BACKUP_ROOT="$SCRIPT_DIR"                    
TODAY=$(date +%F)                            

echo "Current date: $TODAY"


LATEST_BACKUP=""
for dir in "$BACKUP_ROOT"/Backup-*; do
    [ -d "$dir" ] || continue
    DATE_PART=${dir##*-}  

    if [[ $DATE_PART =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        BACKUP_DATE=$(date -d "$DATE_PART" +%s)  
        CURRENT_DATE=$(date +%s)  
        DIFF=$(( (CURRENT_DATE - BACKUP_DATE) / 86400 ))  

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
    else
        echo "Restore directory already exists."
    fi

    
    for FILE in "$LATEST_BACKUP"/*; do
        BASENAME=$(basename "$FILE")

        
        if [[ "$BASENAME" =~ \.[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
            echo "Skipping versioned file: $BASENAME"
            continue
        fi

        
        if [ -f "$RESTORE_DIR/$BASENAME" ]; then
            echo "File $BASENAME already exists in restore directory, skipping."
        else
            
            cp "$FILE" "$RESTORE_DIR/$BASENAME"
            echo "Restored: $BASENAME"
        fi
    done
    echo "Restore completed."
fi
