#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 filename" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/source"
TRASH_DIR="$HOME/.trash"
TRASH_LOG="$HOME/.trash.log"

if [ ! -f "$TRASH_LOG" ]; then
    echo "Error: trash log not found" >&2
    exit 1
fi

TARGET_NAME="$1"
FOUND=0

while IFS= read -r LINE; do
    if [[ "$LINE" =~ \'(.*)\'\ -\>\ ([0-9.]+)$ ]]; then
        FILE="${BASH_REMATCH[1]}"
        ID="${BASH_REMATCH[2]}"
        if [ "$(basename "$FILE")" = "$TARGET_NAME" ]; then
            FOUND=1
            TRASH_FILE="$TRASH_DIR/$ID"
            
            if [ ! -f "$TRASH_FILE" ]; then
                echo "Warning: File exists in log but not in trash (ID: $ID)" >&2
                continue
            fi

            read -rp "Restore '$TARGET_NAME' to $SOURCE_DIR/? [y/n] " ANSWER
            if [[ "$ANSWER" =~ ^[yY] ]]; then
                if [ -e "$SOURCE_DIR/$TARGET_NAME" ]; then
                    read -rp "File exists. Enter new name: " NEW_NAME
                    RESTORE_PATH="$SOURCE_DIR/$NEW_NAME"
                else
                    RESTORE_PATH="$SOURCE_DIR/$TARGET_NAME"
                fi

                if ln -- "$TRASH_FILE" "$RESTORE_PATH"; then
                    rm -f "$TRASH_FILE"
                    grep -vF "$LINE" "$TRASH_LOG" > "$TRASH_LOG.tmp" && \
                    mv "$TRASH_LOG.tmp" "$TRASH_LOG"
                    echo "Successfully restored to $RESTORE_PATH"
                    exit 0
                else
                    echo "Error: Failed to restore (check permissions)" >&2
                fi
            fi
        fi
    fi
done < "$TRASH_LOG"

if [ $FOUND -eq 0 ]; then
    echo "Error: File '$TARGET_NAME' not found in trash log" >&2
fi
exit 1