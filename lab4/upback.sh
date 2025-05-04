#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
RESTORE_DIR="$SCRIPT_DIR/restore"
BACKUP_ROOT="$SCRIPT_DIR"
TODAY=$(date +%F)

echo "[INFO] Текущая дата: $TODAY"
echo "[INFO] Ищем бэкапы в директории: $BACKUP_ROOT"
echo "[INFO] Список каталогов Backup-*:"
ls -d "$BACKUP_ROOT"/Backup-* 2>/dev/null || echo "[WARNING] Ни одного каталога не найдено"

LATEST_BACKUP=""
LATEST_DATE=0

for dir in "$BACKUP_ROOT"/Backup-*; do
    [ -d "$dir" ] || continue
    BASENAME=$(basename "$dir")
    DATE_PART=${BASENAME##*-}

    if [[ $DATE_PART =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        BACKUP_DATE=$(date -d "$DATE_PART" +%s)
        CURRENT_DATE=$(date +%s)
        DIFF=$(( (CURRENT_DATE - BACKUP_DATE) / 86400 ))

        echo "[DEBUG] Проверяется: $dir | Дата: $DATE_PART | Разница: $DIFF дней"

        if [ "$DIFF" -lt 7 ] && [ "$BACKUP_DATE" -gt "$LATEST_DATE" ]; then
            LATEST_BACKUP="$dir"
            LATEST_DATE=$BACKUP_DATE
        fi
    else
        echo "[WARNING] Имя каталога не содержит корректной даты: $dir"
    fi
done

if [ -z "$LATEST_BACKUP" ]; then
    echo "[ERROR] Нет подходящего бэкапа за последние 7 дней."
    exit 1
else
    echo "[INFO] Найден актуальный бэкап: $LATEST_BACKUP"
fi

# Создаём restore/
if [ ! -d "$RESTORE_DIR" ]; then
    mkdir "$RESTORE_DIR"
    echo "[INFO] Создан каталог восстановления: $RESTORE_DIR"
else
    echo "[INFO] Каталог восстановления уже существует: $RESTORE_DIR"
fi

# Копируем файлы без версий
for FILE in "$LATEST_BACKUP"/*; do
    BASENAME=$(basename "$FILE")

    if [[ "$BASENAME" =~ \.[0-9]{4}-[0-9]{2}-[0-9]{2}(\.[0-9]+)?$ ]]; then
        echo "[SKIP] Пропущен версионный файл: $BASENAME"
        continue
    fi

    if [ -f "$RESTORE_DIR/$BASENAME" ]; then
        echo "[SKIP] Уже существует в restore/: $BASENAME"
    else
        cp "$FILE" "$RESTORE_DIR/$BASENAME"
        echo "[RESTORED] Восстановлен файл: $BASENAME"
    fi
done

echo "[DONE] Восстановление завершено."
