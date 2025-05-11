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
    echo "Error: Trash log not found at $TRASH_LOG" >&2
    exit 1
fi

while IFS= read -r LINE; do
    [ -z "$LINE" ] && continue
    
    if [[ "$LINE" =~ ^\'(.*)\'\ -\>\ ([0-9.]+)$ ]]; then
        FILE="${BASH_REMATCH[1]}"
        ID="${BASH_REMATCH[2]}"
        
        if [ "$(basename "$FILE")" = "$1" ]; then
            echo "Found: $FILE (ID: $ID)"
            
            if [ ! -f "$TRASH_DIR/$ID" ]; then
                echo "Error: File missing in trash (ID: $ID)" >&2
                continue
            fi
            
            if [ "$AUTO_CONFIRM" = "y" ]; then
                ANSWER="y"
            else
                read -rp "Restore to $SOURCE_DIR/? [y/n] " ANSWER
            fi
            
            if [[ "$ANSWER" =~ ^[yY] ]]; then
                mkdir -p "$SOURCE_DIR" || {
                    echo "Error: Can't create $SOURCE_DIR" >&2
                    exit 1
                }
                
                if ln -- "$TRASH_DIR/$ID" "$SOURCE_DIR/$1" 2>/dev/null; then
                    rm -f "$TRASH_DIR/$ID"
                    # Атомарное обновление лога
                    grep -vF "$LINE" "$TRASH_LOG" > "$TRASH_LOG.tmp" && \
                    mv "$TRASH_LOG.tmp" "$TRASH_LOG"
                    echo "Successfully restored to $SOURCE_DIR/$1"
                    exit 0
                else
                    echo "Error: Restore failed (check permissions/space?)" >&2
                    exit 1
                fi
            fi
        fi
    fi
done < <(grep -a "$1" "$TRASH_LOG")

echo "Error: File '$1' not found in trash log" >&2
exit 1