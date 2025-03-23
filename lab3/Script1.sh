#!/bin/bash

HOME_DIR="$HOME"
TEST_DIR="$HOME_DIR/test"
REPORT_FILE="$HOME_DIR/report"

mkdir -p "$TEST_DIR"

echo "catalog test was created successfully" >> "$REPORT_FILE"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
touch "$TEST_DIR/$TIMESTAMP"

ping -c 1 www.net_nikogo.ru >/dev/null 2>&1

echo "$(date +"%Y-%m-%d %H:%M:%S") Host unreachable error" >> "$REPORT_FILE"
