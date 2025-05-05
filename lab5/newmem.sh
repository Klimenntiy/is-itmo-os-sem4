#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <N>"
    exit 1
fi

N=$1
arr=()
step=0

while true; do
    arr+=({1..10})
    ((step++))

    if (( ${#arr[@]} > N )); then
        exit 0
    fi
done