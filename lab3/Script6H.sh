#!/bin/bash

current_value=1
mode="+"         


addition() {
    mode="+" 
}


multiplication() {
    mode="*"
}

terminate() {
    echo "Процесс завершён по сигналу от другого процесса."
    exit 0
}

trap 'addition' USR1
trap 'multiplication' USR2
trap 'terminate' SIGTERM

echo "Обработчик запущен. PID $$"

while true; do
    sleep 1

    if [[ "$mode" == "+" ]]; then
        current_value=$((current_value + 2))
    elif [[ "$mode" == "*" ]]; then
        current_value=$((current_value * 2))
    fi

    echo "Текущее значение: $current_value"
done
