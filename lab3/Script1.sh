#!/bin/bash

REPORT_FILE="/home/klimenntiy/report"
TEST_DIR="/home/klimenntiy/test"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p "$TEST_DIR"

echo "$(date +"%Y-%m-%d %H:%M:%S") - Directory $TEST_DIR created successfully." >> "$REPORT_FILE"

touch "$TEST_DIR/$TIMESTAMP"
echo "$(date +"%Y-%m-%d %H:%M:%S") - File $TIMESTAMP created in $TEST_DIR." >> "$REPORT_FILE"

ping -c 1 www.net_nikogo.ru >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "$(date +"%Y-%m-%d %H:%M:%S") - Host unreachable error." >> "$REPORT_FILE"
else
    echo "$(date +"%Y-%m-%d %H:%M:%S") - Host reachable." >> "$REPORT_FILE"
fi

sync
