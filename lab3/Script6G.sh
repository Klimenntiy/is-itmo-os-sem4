#!/bin/bash

read -p "Введите PID обработчика: " PROCESSOR_PID

while true; do
    read -p "Введите команду (+, *, TERM): " input

    case "$input" in
        "+") kill -USR1 $PROCESSOR_PID ;;
        "*") kill -USR2 $PROCESSOR_PID ;;
        "TERM") kill -TERM $PROCESSOR_PID 
               echo "Генератор завершает работу."
               exit 0
               ;;
        *) echo "Неверный ввод, игнорируем." ;;
    esac
done
