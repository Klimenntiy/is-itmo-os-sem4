#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 filename" >&2
    exit 1
fi

FILENAME="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FILE_PATH="$SCRIPT_DIR/$FILENAME"

echo "SCRIPT_DIR: $SCRIPT_DIR" >&2
echo "FILE_PATH: $FILE_PATH" >&2

if [ ! -f "$FILE_PATH" ]; then
    echo "File '$FILENAME' does not exist in the script's directory." >&2
    exit 1
fi

TRASH_DIR="$HOME/.trash"
TRASH_LOG="$HOME/.trash.log"

mkdir -p "$TRASH_DIR" || { echo "Failed to create $TRASH_DIR" >&2; exit 1; }

LINK_ID=1
while [ -e "$TRASH_DIR/$LINK_ID" ]; do
    ((LINK_ID++))
done

echo "Moving file '$FILE_PATH' to trash as '$LINK_ID'..." >&2
mv -- "$FILE_PATH" "$TRASH_DIR/$LINK_ID" || { echo "Failed to move file to trash" >&2; exit 1; }


printf "%q -> %d\n" "$FILE_PATH" "$LINK_ID" >> "$TRASH_LOG" || { echo "Failed to write to trash.log" >&2; exit 1; }

echo "File '$FILENAME' moved to trash as '$LINK_ID'" >&2
exit 0