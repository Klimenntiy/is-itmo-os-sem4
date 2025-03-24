#!/bin/bash

PID1=$(cat /tmp/pid1.txt)
PID3=$(cat /tmp/pid3.txt)

if ps -p $PID1 > /dev/null
then
    echo "Процесс $PID1 найден. Ограничиваем CPU."

    sudo taskset -cp 1 $PID1

    renice -n 19 -p $PID1
    echo "Процесс $PID1 теперь работает только на 1 ядре и с минимальным приоритетом."
else
    echo "Процесс $PID1 не найден."
fi

if ps -p $PID3 > /dev/null
then
    kill $PID3
    echo "Процесс $PID3 завершен."
else
    echo "Процесс $PID3 не найден."
fi
