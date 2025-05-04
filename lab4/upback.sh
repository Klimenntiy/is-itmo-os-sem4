#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
SOURCE_DIR="$SCRIPT_DIR/source"
BACKUP_ROOT="$SCRIPT_DIR"  
REPORT_FILE="$SCRIPT_DIR/backup-report"
TODAY=$(date +%F)

if [ ! -d "$SOURCE_DIR" ]; then
    mkdir "$SOURCE_DIR"
    echo "test content 1" > "$SOURCE_DIR/file1.txt"
    echo "test content 2" > "$SOURCE_DIR/file2.txt"
    echo "[INFO] Created source/ and added test files."
fi

LATEST_BACKUP=""
for dir in "$BACKUP_ROOT"/Backup-*; do
    [ -d "$dir" ] || continue
    DATE_PART=${dir##*-}  
    if [[ $DATE_PART =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        DIFF=$(( ($(date +%s) - $(date -d "$DATE_PART" +%s)) / 86400 ))  # Разница в днях
        if [ "$DIFF" -lt 7 ]; then
            LATEST_BACKUP="$dir"  
            break
        fi
    fi
done

if [ -z "$LATEST_BACKUP" ]; then
    BACKUP_DIR="$BACKUP_ROOT/Backup-$TODAY"
    
    if [ -d "$BACKUP_DIR" ]; then
        echo "Backup directory $BACKUP_DIR already exists. Skipping directory creation."
    else
        mkdir "$BACKUP_DIR"  
        echo "[$TODAY] Backup directory created: $BACKUP_DIR" >> "$REPORT_FILE"
    fi
    
    cp "$SOURCE_DIR"/* "$BACKUP_DIR"/ 2>/dev/null

    {
        echo "Files copied:"
        ls "$SOURCE_DIR"
        echo
    } >> "$REPORT_FILE"
else
    BACKUP_DIR="$LATEST_BACKUP"
    echo "[$TODAY] Updated existing backup: $BACKUP_DIR" >> "$REPORT_FILE"

    for FILE in "$SOURCE_DIR"/*; do
        BASENAME=$(basename "$FILE")
        DEST="$BACKUP_DIR/$BASENAME"

        if [ ! -f "$DEST" ]; then
            cp "$FILE" "$DEST"  
            echo "$BASENAME" >> "$REPORT_FILE"
        else
            if ! cmp -s "$FILE" "$DEST"; then
                VERSION=1
                NEW_DEST="$DEST.$TODAY.$VERSION"
                while [ -f "$NEW_DEST" ]; do
                    VERSION=$((VERSION + 1))
                    NEW_DEST="$DEST.$TODAY.$VERSION"
                done

                mv "$DEST" "$NEW_DEST" 
                cp "$FILE" "$DEST"      
                echo "$BASENAME $BASENAME.$TODAY" >> "$REPORT_FILE"
            fi
        fi
    done
    echo >> "$REPORT_FILE"
fi
