#!/bin/bash

multiply_numbers() {
    while true
    do
        echo $((2 * 2)) > /dev/null
    done
}

multiply_numbers &
PID1=$!            

multiply_numbers &  
PID2=$!           

multiply_numbers & 
PID3=$!             

echo "Процессы запущены с PID: $PID1, $PID2, $PID3"
