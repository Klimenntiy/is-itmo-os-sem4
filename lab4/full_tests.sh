#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
LOG="$SCRIPT_DIR/test-log.txt"
SOURCE_DIR="$SCRIPT_DIR/source"
RESTORE_DIR="$SCRIPT_DIR/restore"

echo "===== FULL TEST STARTED =====" > "$LOG"
echo "[1] Создание тестовых файлов..." | tee -a "$LOG"
"$SCRIPT_DIR/create_test_files.sh" >> "$LOG" 2>&1

echo "[2] Запуск backup.sh..." | tee -a "$LOG"
"$SCRIPT_DIR/backup.sh" >> "$LOG" 2>&1

FILE_TO_DELETE="file with spaces.txt"
echo "[3] Удаление файла через trash.sh: $FILE_TO_DELETE" | tee -a "$LOG"
"$SCRIPT_DIR/trash.sh" "$FILE_TO_DELETE" >> "$LOG" 2>&1

echo "[4] Проверка, удалён ли файл..." | tee -a "$LOG"
if [ ! -f "$SOURCE_DIR/$FILE_TO_DELETE" ]; then
  echo "Файл успешно удалён" | tee -a "$LOG"
else
  echo "Файл всё ещё существует!" | tee -a "$LOG"
fi

echo "[5] Восстановление файла через untrash.sh..." | tee -a "$LOG"
echo "y" | "$SCRIPT_DIR/untrash.sh" "$FILE_TO_DELETE" >> "$LOG" 2>&1

echo "[6] Проверка восстановления..." | tee -a "$LOG"
if [ -f "$SOURCE_DIR/$FILE_TO_DELETE" ]; then
  echo "Файл восстановлен в source/" | tee -a "$LOG"
else
  echo "Файл не восстановлен!" | tee -a "$LOG"
fi

echo "[7] Запуск восстановления из последнего бэкапа (upback.sh)..." | tee -a "$LOG"
"$SCRIPT_DIR/upback.sh" >> "$LOG" 2>&1

echo "[8] Проверка restore/ каталога..." | tee -a "$LOG"
if [ -d "$RESTORE_DIR" ] && [ "$(ls -A "$RESTORE_DIR")" ]; then
  echo "Файлы успешно восстановлены в restore/" | tee -a "$LOG"
else
  echo "Каталог restore пуст или не создан!" | tee -a "$LOG"
fi

echo "===== FULL TEST COMPLETE =====" | tee -a "$LOG"
echo "Лог сохранён в: $LOG"
