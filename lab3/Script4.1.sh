#!/bin/bash

renice -n 10 -p $PID1
echo "Процесс с PID $PID1 ограничен на 10% процессора."

kill $PID3
echo "Процесс с PID $PID3 завершен."

