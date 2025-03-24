#!/bin/bash

PID1=$(cat /tmp/pid1.txt)
PID2=$(cat /tmp/pid2.txt)
PID3=$(cat /tmp/pid3.txt)

if ps -p $PID1 > /dev/null
then
    echo "Процесс с PID $PID1 найден."

    renice -n 19 -p $PID1
    echo "Приоритет процесса с PID $PID1 снижен до 19."

    sudo mkdir -p /sys/fs/cgroup/cpu/limitgroup
    sudo bash -c "echo +cpu > /sys/fs/cgroup/cgroup.subtree_control"

    sudo bash -c "echo 50000 > /sys/fs/cgroup/cpu/limitgroup/cpu.max"

    sudo bash -c "echo $PID1 > /sys/fs/cgroup/cpu/limitgroup/cgroup.procs"

    echo "Процесс с PID $PID1 теперь использует максимум 5% CPU."
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
