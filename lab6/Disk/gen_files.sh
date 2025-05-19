#!/bin/bash
mkdir -p test_files
for i in {1..20}; do
    yes 1 | head -n 2500000 > test_files/file_$i.txt
done
