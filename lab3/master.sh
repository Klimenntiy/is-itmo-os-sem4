#!/bin/bash

PIPE="game_pipe"

rm -f $PIPE
mkfifo $PIPE

player1_score=0
player2_score=0

declare -A rules=( 
    ["Rock-Scissors"]=1
    ["Scissors-Paper"]=1
    ["Paper-Rock"]=1
    ["Scissors-Rock"]=2
    ["Paper-Scissors"]=2
    ["Rock-Paper"]=2
)

echo "Waiting for players to join..."

while [[ $player1_score -lt 3 && $player2_score -lt 3 ]]; do
    if ! read -t 5 p1_id p1_choice < $PIPE; then
        echo "No input from players. Waiting..."
        continue
    fi

    echo "Player 1 chose: $p1_choice"
    echo "Player 2 chose: $p2_choice"

    if [[ $p1_choice == $p2_choice ]]; then
        echo "It's a tie!"
    else
        winner=${rules["$p1_choice-$p2_choice"]}
        if [[ $winner -eq 1 ]]; then
            ((player1_score++))
            echo "Player 1 wins! Score: $player1_score - $player2_score"
        else
            ((player2_score++))
            echo "Player 2 wins! Score: $player1_score - $player2_score"
        fi
    fi
done

if [[ $player1_score -eq 3 ]]; then
    echo "Player 1 wins the match!"
else
    echo "Player 2 wins the match!"
fi

rm -f $PIPE
