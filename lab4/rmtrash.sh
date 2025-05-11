#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 filename" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/source"
TRASH_DIR="$HOME/.trash"
TRASH_LOG="$HOME/.trash.log"

mkdir -p "$TRASH_DIR" || { echo "Cannot create trash dir" >&2; exit 1; }
touch "$TRASH_LOG" || { echo "Cannot create trash log" >&2; exit 1; }

FILENAME="$1"
if [ ! -f "$SOURCE_DIR/$FILENAME" ]; then
    echo "Error: File '$FILENAME' not found in $SOURCE_DIR" >&2
    exit 1
fi

LINK_ID=$(date +%s.%N)

{
    printf "'%s' -> %s\n" "$(realpath -- "$SOURCE_DIR/$FILENAME")" "$LINK_ID"
} >> "$TRASH_LOG" || { echo "Error writing to log" >&2; exit 1; }

mv -- "$SOURCE_DIR/$FILENAME" "$TRASH_DIR/$LINK_ID" || {
    echo "Error moving to trash" >&2
    sed -i '$d' "$TRASH_LOG"  # Откат записи
    exit 1
}

echo "Moved to trash with ID: $LINK_ID"
exit 0