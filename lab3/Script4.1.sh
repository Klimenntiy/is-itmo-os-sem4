#!/bin/bash

if ps -p $PID1 > /dev/null
then
    echo "Процесс с PID $PID1 найден."
else
    echo "Процесс с PID $PID1 не найден."
fi

renice -n 10 -p $PID1
echo "Приоритет процесса с PID $PID1 снижен до 10."

if ps -p $PID3 > /dev/null
then
    kill $PID3
    echo "Процесс с PID $PID3 завершен."
else
    echo "Процесс с PID $PID3 не найден."
fi
