#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/source"  
TRASH_DIR="$HOME/.trash"
TRASH_LOG="$HOME/.trash.log"
TMP_LOG=$(mktemp) || { echo "Ошибка: не удалось создать временный файл" >&2; exit 1; }

if [ $# -ne 1 ]; then
    echo "Использование: $0 имя_файла" >&2
    exit 1
fi
TARGET_NAME="$1"

if [ ! -f "$TRASH_LOG" ]; then
    echo "Ошибка: файл лога $TRASH_LOG не найден" >&2
    exit 1
fi

FOUND=0
while IFS= read -r LINE; do
    FILE_IN_LOG=$(basename "$(echo "$LINE" | awk -F' -> ' '{print $1}' | tr -d "'")")
    if [ "$FILE_IN_LOG" = "$TARGET_NAME" ]; then
        FOUND=1
        LINK_ID=$(echo "$LINE" | awk -F' -> ' '{print $2}')
        TRASH_FILE="$TRASH_DIR/$LINK_ID"

        if [ ! -f "$TRASH_FILE" ]; then
            echo "Предупреждение: файл $TARGET_NAME (ID $LINK_ID) отсутствует в корзине" >&2
            continue
        fi

        read -rp "Восстановить файл '$TARGET_NAME' в $SOURCE_DIR? [y/n] " ANSWER
        if [[ "$ANSWER" =~ ^[yY] ]]; then
            
            mkdir -p "$SOURCE_DIR" || {
                echo "Ошибка: не удалось создать $SOURCE_DIR" >&2
                continue
            }

            if [ -e "$SOURCE_DIR/$TARGET_NAME" ]; then
                read -rp "Файл '$TARGET_NAME' уже существует. Введите новое имя: " NEW_NAME
                RESTORE_PATH="$SOURCE_DIR/$NEW_NAME"
            else
                RESTORE_PATH="$SOURCE_DIR/$TARGET_NAME"
            fi

            if ln "$TRASH_FILE" "$RESTORE_PATH" 2>/dev/null; then
                echo "Файл успешно восстановлен в $RESTORE_PATH"
                rm -f "$TRASH_FILE"
                grep -vF "$LINE" "$TRASH_LOG" > "$TMP_LOG" && mv "$TMP_LOG" "$TRASH_LOG"
            else
                echo "Ошибка: не удалось восстановить файл. Проверьте права доступа." >&2
            fi
        fi
    fi
done < "$TRASH_LOG"

if [ $FOUND -eq 0 ]; then
    echo "Файл '$TARGET_NAME' не найден в логе корзины" >&2
fi

rm -f "$TMP_LOG"
exit 0