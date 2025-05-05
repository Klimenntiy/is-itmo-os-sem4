#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <N> <K>"
    exit 1
fi

N=$1
K=$2

for ((i = 1; i <= K; i++)); do
    ./newmem.sh "$N" &
    sleep 1
done
