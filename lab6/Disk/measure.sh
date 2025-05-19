#!/bin/bash
N=$1
MODE=$2 # seq или par
OUTFILE="results_disk_${MODE}_${N}.txt"

for ((i=1; i<=10; i++)); do
    /usr/bin/time -f "%e" -o tmp_time.txt ./run_${MODE}.sh $N
    cat tmp_time.txt >> $OUTFILE
done
