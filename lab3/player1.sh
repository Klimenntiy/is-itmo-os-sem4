#!/bin/bash

PIPE="game_pipe"
[[ -p $PIPE ]] || mkfifo $PIPE

while true; do
    sleep 1
    choice=$(shuf -n1 -e Rock Scissors Paper)
    echo "Игрок 1: $choice"
    echo "1 $choice" > $PIPE
done
