#!/bin/bash

PIPE="pipi"

if [[ ! -p $PIPE ]]; then
    mkfifo $PIPE
fi

echo "Генератор запущен. Введите команды (+, *, число, QUIT):"

while true; do
    read input
    echo "$input" > $PIPE 
    if [[ "$input" == "QUIT" ]]; then
        break
    fi
done

echo "Генератор завершает работу."
