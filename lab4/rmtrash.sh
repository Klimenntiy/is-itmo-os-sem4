#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 filename" >&2
    exit 1
fi

FILENAME="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/source"
TRASH_DIR="$HOME/.trash"
TRASH_LOG="$HOME/.trash.log"

mkdir -p "$TRASH_DIR" || { echo "Cannot create $TRASH_DIR" >&2; exit 1; }
touch "$TRASH_LOG" || { echo "Cannot create $TRASH_LOG" >&2; exit 1; }

LINK_ID=$(date +%s)

printf "'%s' -> %s\n" "$(realpath -- "$SOURCE_DIR/$FILENAME")" "$LINK_ID" >> "$TRASH_LOG" || {
    echo "Failed to write to trash.log" >&2
    exit 1
}

mv -- "$SOURCE_DIR/$FILENAME" "$TRASH_DIR/$LINK_ID" || {
    echo "Failed to move file to trash" >&2
    sed -i '$d' "$TRASH_LOG"
    exit 1
}

echo "File moved to trash with ID: $LINK_ID"
exit 0