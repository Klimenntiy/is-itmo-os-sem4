#!/bin/bash

> full.log

awk '/WW/ { gsub(/WW/, "Warning:"); print }' /var/log/anaconda/journal.log >> full.log

awk '/II/ { gsub(/II/, "Information:"); print }' /var/log/anaconda/journal.log >> full.log

cat full.log
