#!/bin/bash
N=$1
for ((i=1; i<=N; i++)); do
    ./calc_task.sh $((i + 10000)) > /dev/null &
done
wait
