#!/bin/bash

PID1=$(cat /tmp/pid1.txt)
PID2=$(cat /tmp/pid2.txt)
PID3=$(cat /tmp/pid3.txt)

if ps -p $PID1 > /dev/null
then
    echo "Процесс с PID $PID1 найден."
    renice -n 10 -p $PID1
    echo "Приоритет процесса с PID $PID1 снижен до 10."
else
    echo "Процесс с PID $PID1 не найден."
fi

if ps -p $PID3 > /dev/null
then
    kill $PID3
    echo "Процесс с PID $PID3 завершен."
else
    echo "Процесс с PID $PID3 не найден."
fi
