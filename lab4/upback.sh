#!/bin/bash

# Определяем пути
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
RESTORE_DIR="$SCRIPT_DIR/restore"  # Папка для восстановления
BACKUP_ROOT="$SCRIPT_DIR"  # Корневая папка для резервных копий
TODAY=$(date +%F)

echo "Current date: $TODAY"  # Печатаем текущую дату

# Ищем самую свежую резервную копию (в пределах последних 7 дней)
LATEST_BACKUP=""
echo "Looking for backup directories..."
for dir in "$BACKUP_ROOT"/Backup-*; do
    [ -d "$dir" ] || continue
    DATE_PART=${dir##*-}  # Получаем дату из имени каталога
    echo "Found backup directory: $dir (Date: $DATE_PART)"  # Диагностика

    # Проверяем, соответствует ли дата формату YYYY-MM-DD
    if [[ $DATE_PART =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        BACKUP_DATE=$(date -d "$DATE_PART" +%s)  # Переводим дату из имени в формат timestamp
        CURRENT_DATE=$(date +%s)  # Текущая дата в формате timestamp
        DIFF=$(( (CURRENT_DATE - BACKUP_DATE) / 86400 ))  # Разница в днях
        echo "Backup date: $DATE_PART (timestamp: $BACKUP_DATE)"
        echo "Current date: $TODAY (timestamp: $CURRENT_DATE)"
        echo "Date difference: $DIFF days"  # Диагностика

        # Если разница меньше 7 дней, считаем резервную копию актуальной
        if [ "$DIFF" -lt 7 ]; then
            LATEST_BACKUP="$dir"  # Если разница меньше 7 дней, считаем резервную копию актуальной
            break
        fi
    fi
done

# Если актуальный бекап найден, восстанавливаем файлы
if [ -z "$LATEST_BACKUP" ]; then
    echo "No recent backup found within the last 7 days."
    exit 1
else
    echo "Latest backup found: $LATEST_BACKUP"
    
    # Создаем каталог для восстановления, если он не существует
    if [ ! -d "$RESTORE_DIR" ]; then
        mkdir "$RESTORE_DIR"
        echo "Created restore directory."
    fi

    # Копируем файлы из актуального бекапа в папку restore/
    for FILE in "$LATEST_BACKUP"/*; do
        BASENAME=$(basename "$FILE")

        # Пропускаем файлы с версиями (например, file1.txt.2025-05-04)
        if [[ "$BASENAME" =~ \.[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
            echo "Skipping versioned file: $BASENAME"
            continue
        fi

        # Проверяем, существует ли файл в папке восстановления
        if [ -f "$RESTORE_DIR/$BASENAME" ]; then
            echo "File $BASENAME already exists in restore directory, skipping."
        else
            # Копируем актуальные файлы в папку восстановления
            cp "$FILE" "$RESTORE_DIR/$BASENAME"
            echo "Restored: $BASENAME"
        fi
    done
    echo "Restore completed."
fi
