#!/bin/bash
USER="klimenntiy"
OUTPUT="output.txt"

ps -u $USER --no-header | wc -l > $OUTPUT
ps -u $USER -o pid,cmd --no-header | awk '{print $1 ":" $2}' >> $OUTPUT
