#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
SOURCE_DIR="$SCRIPT_DIR"
BACKUP_ROOT="$SCRIPT_DIR"
REPORT_FILE="$SCRIPT_DIR/backup-report"


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
    BACKUP_DIR="$BACKUP_ROOT/Backup-$TODAY"
    mkdir "$BACKUP_DIR"
    cp -r "$SOURCE_DIR"/* "$BACKUP_DIR"/

    {
        echo "[$TODAY] Backup directory created: $BACKUP_DIR"
        echo "Files copied:"
        ls "$SOURCE_DIR"
        echo
    } >> "$REPORT_FILE"
else
    BACKUP_DIR="$LATEST_BACKUP"
    {
        echo "[$TODAY] Updated existing backup: $BACKUP_DIR"
    } >> "$REPORT_FILE"

    for FILE in "$SOURCE_DIR"/*; do
        BASENAME=$(basename "$FILE")
        DEST="$BACKUP_DIR/$BASENAME"

        if [ ! -f "$DEST" ]; then
            cp "$FILE" "$DEST"
            echo "$BASENAME" >> "$REPORT_FILE"
        else
            SRC_SIZE=$(stat -c%s "$FILE")
            DST_SIZE=$(stat -c%s "$DEST")

            if [ "$SRC_SIZE" -ne "$DST_SIZE" ]; then
                mv "$DEST" "$DEST.$TODAY"
                cp "$FILE" "$DEST"
                echo "$BASENAME $BASENAME.$TODAY" >> "$REPORT_FILE"
            fi
        fi
    done
    echo >> "$REPORT_FILE"
fi
