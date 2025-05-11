#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 filename" >&2
    exit 1
fi

FILENAME="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/source"  

if [ ! -f "$SOURCE_DIR/$FILENAME" ]; then
    echo "File '$FILENAME' does not exist in $SOURCE_DIR." >&2
    exit 1
fi

TRASH_DIR="$HOME/.trash"
TRASH_LOG="$HOME/.trash.log"
mkdir -p "$TRASH_DIR" || { echo "Failed to create $TRASH_DIR" >&2; exit 1; }

LINK_ID=1
while [ -e "$TRASH_DIR/$LINK_ID" ]; do
    ((LINK_ID++))
done

mv -- "$SOURCE_DIR/$FILENAME" "$TRASH_DIR/$LINK_ID" || {
    echo "Failed to move file to trash." >&2
    exit 1
}

printf "%q -> %d\n" "$SOURCE_DIR/$FILENAME" "$LINK_ID" >> "$TRASH_LOG" || {
    echo "Failed to write to trash.log." >&2
    exit 1
}

echo "File '$FILENAME' moved to trash as '$LINK_ID'." >&2
exit 0