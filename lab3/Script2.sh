#!/bin/bash

echo "sudo bash /home/klimenntiy/is-itmo-os-sem4/lab3/script1.sh" | at $(date -d "+20 seconds" +"%H:%M") 

sleep 5

tail -f /home/klimenntiy/report
