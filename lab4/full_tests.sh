#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG="$SCRIPT_DIR/test-log.txt"
SOURCE_DIR="$SCRIPT_DIR/source"
RESTORE_DIR="$SCRIPT_DIR/restore"

echo "===== FULL TEST STARTED =====" > "$LOG"
echo "[1] Creating test files..." | tee -a "$LOG"
"$SCRIPT_DIR/create_test_files.sh" >> "$LOG" 2>&1 || {
    echo "Error creating test files" | tee -a "$LOG"
    exit 1
}

echo "[2] Running backup..." | tee -a "$LOG"
"$SCRIPT_DIR/backup.sh" >> "$LOG" 2>&1 || {
    echo "Error during backup" | tee -a "$LOG"
    exit 1
}

FILE_TO_DELETE="file with spaces.txt"
echo "[3] Deleting file: $FILE_TO_DELETE" | tee -a "$LOG"
"$SCRIPT_DIR/rmtrash.sh" "$FILE_TO_DELETE" >> "$LOG" 2>&1 || {
    echo "Error deleting file" | tee -a "$LOG"
    exit 1
}

echo "[4] Verifying deletion..." | tee -a "$LOG"
if [ ! -f "$SOURCE_DIR/$FILE_TO_DELETE" ]; then
    echo "File successfully deleted" | tee -a "$LOG"
else
    echo "File still exists!" | tee -a "$LOG"
    exit 1
fi

echo "[5] Restoring file..." | tee -a "$LOG"
echo "y" | "$SCRIPT_DIR/untrash.sh" "$FILE_TO_DELETE" >> "$LOG" 2>&1 || {
    echo "Error restoring file" | tee -a "$LOG"
    exit 1
}

echo "[6] Verifying restoration..." | tee -a "$LOG"
if [ -f "$SOURCE_DIR/$FILE_TO_DELETE" ]; then
    echo "File successfully restored" | tee -a "$LOG"
else
    echo "File not restored!" | tee -a "$LOG"
    exit 1
fi

echo "[7] Restoring from backup..." | tee -a "$LOG"
"$SCRIPT_DIR/upback.sh" >> "$LOG" 2>&1 || {
    echo "Error restoring from backup" | tee -a "$LOG"
    exit 1
}

echo "[8] Verifying backup restore..." | tee -a "$LOG"
if [ -d "$RESTORE_DIR" ] && [ "$(ls -A "$RESTORE_DIR")" ]; then
    echo "Backup successfully restored" | tee -a "$LOG"
else
    echo "Restore directory is empty!" | tee -a "$LOG"
    exit 1
fi

echo "===== TEST COMPLETED SUCCESSFULLY =====" | tee -a "$LOG"
exit 0