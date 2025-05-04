#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 filename"
    exit 1
fi

TARGET_NAME="$1"
TRASH_DIR="$HOME/.trash"
TRASH_LOG="$HOME/.trash.log"
TMP_LOG="$HOME/.trash_tmp.log"

if [ ! -f "$TRASH_LOG" ]; then
    echo "Trash log not found."
    exit 1
fi

mapfile -t MATCHES < <(grep "/.*/$TARGET_NAME ->" "$TRASH_LOG")

if [ ${#MATCHES[@]} -eq 0 ]; then
    echo "No such file '$TARGET_NAME' found in trash log."
    exit 0
fi

for LINE in "${MATCHES[@]}"; do
    ORIGINAL_PATH=$(echo "$LINE" | cut -d' ' -f1)
    LINK_ID=$(echo "$LINE" | awk '{print $3}')
    TRASH_FILE="$TRASH_DIR/$LINK_ID"

    echo "Restore file to: $ORIGINAL_PATH ? [y/n]"
    read -r ANSWER

    if [[ "$ANSWER" == "y" || "$ANSWER" == "Y" ]]; then
        DEST_DIR=$(dirname "$ORIGINAL_PATH")

        if [ ! -e "$TRASH_FILE" ]; then
            echo "Trash file '$TRASH_FILE' no longer exists. Skipping."
            continue
        fi

        if [ -d "$DEST_DIR" ]; then
            if [ -e "$ORIGINAL_PATH" ]; then
                echo "File '$ORIGINAL_PATH' already exists."
                echo -n "Enter a new name to restore to (in $DEST_DIR): "
                read -r NEW_NAME
                RESTORE_PATH="$DEST_DIR/$NEW_NAME"
            else
                RESTORE_PATH="$ORIGINAL_PATH"
            fi
        else
            echo "Original directory '$DEST_DIR' does not exist. Restoring to home directory."
            RESTORE_PATH="$HOME/$TARGET_NAME"
            if [ -e "$RESTORE_PATH" ]; then
                echo "File '$RESTORE_PATH' already exists."
                echo -n "Enter a new name to restore to (in home directory): "
                read -r NEW_NAME
                RESTORE_PATH="$HOME/$NEW_NAME"
            fi
        fi

        ln "$TRASH_FILE" "$RESTORE_PATH"
        if [ $? -eq 0 ]; then
            echo "Restored to '$RESTORE_PATH'"
            rm "$TRASH_FILE"
            grep -vF "$LINE" "$TRASH_LOG" > "$TMP_LOG" && mv "$TMP_LOG" "$TRASH_LOG"
        else
            echo "Failed to restore file. Skipping."
        fi
    fi
done
