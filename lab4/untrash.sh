#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/source"
TRASH_DIR="$HOME/.trash"
TRASH_LOG="$HOME/.trash.log"

if [ ! -f "$TRASH_LOG" ]; then
    echo "Error: trash log not found" >&2
    exit 1
fi

while IFS= read -r LINE; do
    if ! echo "$LINE" | grep -q " -> "; then continue; fi
    
    FILE_PATH=$(echo "$LINE" | awk -F" -> " '{print $1}' | tr -d "'")
    FILE_NAME=$(basename "$FILE_PATH")
    LINK_ID=$(echo "$LINE" | awk -F" -> " '{print $2}')
    
    if [ "$FILE_NAME" = "$1" ]; then
        echo "Found: $FILE_PATH (ID: $LINK_ID)"
        read -rp "Restore to $SOURCE_DIR/? [y/n] " ANSWER
        if [[ "$ANSWER" =~ ^[yY] ]]; then
            ln -- "$TRASH_DIR/$LINK_ID" "$SOURCE_DIR/$1" && {
                rm -f "$TRASH_DIR/$LINK_ID"
                grep -vF "$LINE" "$TRASH_LOG" > "$TRASH_LOG.tmp" && mv "$TRASH_LOG.tmp" "$TRASH_LOG"
                echo "Successfully restored"
                exit 0
            }
        fi
    fi
done < <(grep -a " -> " "$TRASH_LOG")  

echo "File '$1' not found in trash log" >&2
exit 1