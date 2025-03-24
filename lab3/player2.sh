#!/bin/bash

PIPE="game_pipe"
[[ -p $PIPE ]] || mkfifo $PIPE

while true; do
    sleep 10
    choice=$(shuf -n1 -e Rock Scissors Paper)
    echo "Игрок 2: $choice"
    echo "2 $choice" > $PIPE
done
