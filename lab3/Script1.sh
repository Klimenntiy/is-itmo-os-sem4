#!/bin/bash

HOME_DIR="$HOME"
TEST_DIR="$HOME/test"
REPORT_FILE="$HOME/report"

# Пытаемся создать каталог
mkdir -p "$TEST_DIR"
echo "Created directory $TEST_DIR"

# Проверяем, создаётся ли файл report
if [ ! -f "$REPORT_FILE" ]; then
    echo "report file doesn't exist, creating it"
fi

# Пишем сообщение в report
echo "catalog test was created successfully" >> "$REPORT_FILE"

# Создаём файл с текущей датой и временем
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
touch "$TEST_DIR/$TIMESTAMP"

# Опрос хоста
ping -c 1 www.net_nikogo.ru >/dev/null 2>&1

# Записываем информацию о недоступности хоста
echo "$(date +"%Y-%m-%d %H:%M:%S") Host unreachable error" >> "$REPORT_FILE"

echo "Script completed"
