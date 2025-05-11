#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 filename"
    exit 1
fi

FILENAME="$1"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FILE_PATH="$SCRIPT_DIR/$FILENAME"

echo "SCRIPT_DIR: $SCRIPT_DIR"
echo "FILE_PATH: $FILE_PATH"

if [ ! -f "$FILE_PATH" ]; then
    echo "File '$FILENAME' does not exist in the script's directory."
    exit 1
fi

TRASH_DIR="$HOME/.trash"
TRASH_LOG="$HOME/.trash.log"

mkdir -p "$TRASH_DIR"

LINK_ID=1
while [ -e "$TRASH_DIR/$LINK_ID" ]; do
    ((LINK_ID++))
done

echo "Moving file '$FILE_PATH' to trash as '$LINK_ID'..."
mv "$FILE_PATH" "$TRASH_DIR/$LINK_ID"

echo "$FILE_PATH -> $LINK_ID" >> "$TRASH_LOG"

echo "File '$FILENAME' moved to trash as '$LINK_ID'"
