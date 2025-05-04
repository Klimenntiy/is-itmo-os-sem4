#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
RESTORE_DIR="$SCRIPT_DIR/restore"
BACKUP_ROOT="$SCRIPT_DIR"
TODAY=$(date +%F)

echo "[INFO] Текущая дата: $TODAY"
echo "[INFO] Ищем бэкапы в директории: $BACKUP_ROOT"

# Получаем список каталогов Backup-*
BACKUP_DIRS=$(ls -d "$BACKUP_ROOT"/Backup-* 2>/dev/null)
if [ -z "$BACKUP_DIRS" ]; then
    echo "[ERROR] Ни одного каталога Backup-* не найдено."
    exit 1
else
    echo "[INFO] Найдены каталоги бэкапов:"
    echo "$BACKUP_DIRS"
fi

LATEST_BACKUP=""
LATEST_DATE=0

for dir in $BACKUP_DIRS; do
    [ -d "$dir" ] || continue
    BASENAME=$(basename "$dir")
    DATE_PART=${BASENAME#Backup-}

    # Проверяем формат даты (YYYY-MM-DD)
    if [[ $DATE_PART =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        # Пытаемся преобразовать дату в секунды
        BACKUP_DATE=$(date -d "$DATE_PART" +%s 2>/dev/null)
        if [ -z "$BACKUP_DATE" ]; then
            echo "[WARNING] Не удалось распознать дату в каталоге: $dir"
            continue
        fi

        CURRENT_DATE=$(date +%s)
        DIFF_DAYS=$(( (CURRENT_DATE - BACKUP_DATE) / 86400 ))

        echo "[DEBUG] Проверяем: $dir | Дата: $DATE_PART | Разница: $DIFF_DAYS дней"

        if [ "$DIFF_DAYS" -lt 7 ] && [ "$BACKUP_DATE" -gt "$LATEST_DATE" ]; then
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

# Создаём каталог restore, если его нет
mkdir -p "$RESTORE_DIR"
echo "[INFO] Каталог восстановления: $RESTORE_DIR"

# Восстанавливаем файлы (без версионных копий)
RESTORED_COUNT=0
for FILE in "$LATEST_BACKUP"/*; do
    [ -f "$FILE" ] || continue
    BASENAME=$(basename "$FILE")

    # Пропускаем файлы с датами в имени (версионные копии)
    if [[ "$BASENAME" =~ \.[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "[SKIP] Пропущен версионный файл: $BASENAME"
        continue
    fi

    if [ -f "$RESTORE_DIR/$BASENAME" ]; then
        echo "[SKIP] Файл уже существует в restore/: $BASENAME"
    else
        cp "$FILE" "$RESTORE_DIR/$BASENAME"
        echo "[RESTORED] Восстановлен: $BASENAME"
        ((RESTORED_COUNT++))
    fi
done

echo "[DONE] Восстановление завершено. Всего файлов: $RESTORED_COUNT"