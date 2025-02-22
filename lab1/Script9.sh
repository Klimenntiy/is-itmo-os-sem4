#!/bin/bash

find /var/log/ -name "*.log" -exec wc -l {} + | awk '{sum += $1} END {print sum}'
