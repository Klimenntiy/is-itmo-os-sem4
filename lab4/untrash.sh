#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 filename" >&2
    exit 1
fi

TARGET_NAME="$1"
TRASH_DIR="$HOME/.trash"
TRASH_LOG="$HOME/.trash.log"
TMP_LOG=$(mktemp) || { echo "Cannot create temp file" >&2; exit 1; }

if [ ! -f "$TRASH_LOG" ]; then
    echo "Trash log not found." >&2
    exit 1
fi

mapfile -t MATCHES < <(grep -F "/${TARGET_NAME} ->" "$TRASH_LOG")

if [ ${#MATCHES[@]} -eq 0 ]; then
    echo "No such file '$TARGET_NAME' found in trash log." >&2
    exit 0
fi

for LINE in "${MATCHES[@]}"; do
    ORIGINAL_PATH=$(echo "$LINE" | awk -F' -> ' '{print $1}' | sed "s/^'//; s/'$//")
    LINK_ID=$(echo "$LINE" | awk -F' -> ' '{print $2}')
    TRASH_FILE="$TRASH_DIR/$LINK_ID"

    if [ ! -e "$TRASH_FILE" ]; then
        echo "Trash file '$TRASH_FILE' no longer exists. Skipping." >&2
        continue
    fi

    read -rp "Restore file to: $ORIGINAL_PATH ? [y/n] " ANSWER
    if [[ "$ANSWER" =~ ^[yY] ]]; then
        DEST_DIR=$(dirname "$ORIGINAL_PATH")
        mkdir -p "$DEST_DIR" 2>/dev/null

        if [ -e "$ORIGINAL_PATH" ]; then
            read -rp "File '$ORIGINAL_PATH' exists. Enter new name: " NEW_NAME
            RESTORE_PATH="${DEST_DIR}/${NEW_NAME}"
        else
            RESTORE_PATH="$ORIGINAL_PATH"
        fi

        mkdir -p "$(dirname "$RESTORE_PATH")" || {
            echo "Cannot create destination directory" >&2
            continue
        }

        if ln "$TRASH_FILE" "$RESTORE_PATH" 2>/dev/null; then
            echo "Restored to '$RESTORE_PATH'"
            rm -f "$TRASH_FILE"
            grep -vF "$LINE" "$TRASH_LOG" > "$TMP_LOG" && mv "$TMP_LOG" "$TRASH_LOG"
        else
            echo "Failed to restore file. Check permissions." >&2
        fi
    fi
done

rm -f "$TMP_LOG"
exit 0