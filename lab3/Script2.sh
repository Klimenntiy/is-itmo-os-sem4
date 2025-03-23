#!/bin/bash

echo "./home/klimenntiy/is-itmo-os-sem4/lab3/script1.sh" | at $(date -d "+20 seconds" +"%H:%M")

sleep 5

tail -n 0 -f /home/klimenntiy/report
