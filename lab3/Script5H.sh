#!/bin/bash

PIPE="pipi"
mode="addition"
current_value=1

if [[ ! -p $PIPE ]]; then
    mkfifo $PIPE
fi

echo "Обработчик запущен. Начальное значение: $current_value (режим: сложение)"

tail -f $PIPE | while read input; do
    if [[ $input == "+" ]]; then
        mode="addition"
        echo "Режим изменен на сложение."

    elif [[ $input == "*" ]]; then
        mode="multiplication"
        echo "Режим изменен на умножение."

    elif [[ $input =~ ^[0-9]+$ ]]; then
        if [[ $mode == "addition" ]]; then
            current_value=$((current_value + input))
        elif [[ $mode == "multiplication" ]]; then
            current_value=$((current_value * input))
        fi
        echo "Текущий результат: $current_value"

    elif [[ $input == "QUIT" ]]; then
        echo "Плановая остановка. Итоговый результат: $current_value"
        break

    else
        echo "Ошибка: неверный ввод ('$input'). Завершаем работу."
        break
    fi
done

rm -f $PIPE
