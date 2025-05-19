#!/bin/bash
N=$1
for ((i=1; i<=N; i++)); do
    ./process_file.sh test_files/file_$i.txt &
done
wait
