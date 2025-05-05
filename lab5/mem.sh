#!/bin/bash

: > report.log

arr=()
step=0

while true; do
    arr+=({1..10})
    ((step++))

    if (( step % 100000 == 0 )); then
        echo "${#arr[@]}" >> report.log
    fi
done
