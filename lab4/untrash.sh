#!/bin/bash

# Жёсткие настройки
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/source"
TRASH_DIR="$HOME/.trash"
TRASH_LOG="$HOME/.trash.log"

if [ $# -ne 1 ]; then
    echo "Usage: $0 filename" >&2
    exit 1
fi

if [ ! -s "$TRASH_LOG" ]; then
    echo "Error: Trash log is empty" >&2
    exit 1
fi

TARGET_NAME="$1"
MATCHES=()
while IFS= read -r LINE; do
    if [[ "$LINE" =~ \'(.*)\'\ -\>\ ([0-9.]+)$ ]]; then
        FILE="${BASH_REMATCH[1]}"
        ID="${BASH_REMATCH[2]}"
        if [ "$(basename "$FILE")" = "$TARGET_NAME" ]; then
            MATCHES+=("$ID:$FILE")
        fi
    fi
done < <(tac "$TRASH_LOG")

if [ ${#MATCHES[@]} -eq 0 ]; then
    echo "Error: File '$TARGET_NAME' not found in trash log" >&2
    exit 1
fi

IFS=':' read -r LINK_ID FILE_PATH <<< "${MATCHES[0]}"
TRASH_FILE="$TRASH_DIR/$LINK_ID"

if [ ! -f "$TRASH_FILE" ]; then
    echo "Error: File exists in log but missing in trash (ID: $LINK_ID)" >&2
    exit 1
fi

if [ "$AUTO_CONFIRM" = "y" ]; then
    ANSWER="y"
else
    read -rp "Restore '$TARGET_NAME' to $SOURCE_DIR/? [y/n] " ANSWER
fi

if [[ "$ANSWER" =~ ^[yY] ]]; then
    mkdir -p "$SOURCE_DIR" || {
        echo "Error: Can't create $SOURCE_DIR" >&2
        exit 1
    }

    if ln -- "$TRASH_FILE" "$SOURCE_DIR/$TARGET_NAME" 2>/dev/null; then
        grep -v "/$TARGET_NAME' -> " "$TRASH_LOG" > "$TRASH_LOG.tmp" && \
        mv "$TRASH_LOG.tmp" "$TRASH_LOG"
        
        rm -f "$TRASH_FILE"
        echo "Successfully restored to $SOURCE_DIR/$TARGET_NAME"
        exit 0
    else
        echo "Error: Failed to restore (target exists?): $SOURCE_DIR/$TARGET_NAME" >&2
        exit 1
    fi
fi

exit 0