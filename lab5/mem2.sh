#!/bin/bash

: > report2.log

arr=()
step=0

while true; do
    arr+=({1..10})
    ((step++))

    if (( step % 100000 == 0 )); then
        echo "${#arr[@]}" >> report2.log
    fi
done
