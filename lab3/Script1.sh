#!/usr/bin/bash

mkdir /home/klimenntiy/test && echo "catalog test was created successfully" >> /home/klimenntiy/report && touch /home/klimenntiy/test/$(date +%Y-%m-%d_%H-%M-%S)

ping net_nikogo.ru > /dev/null || echo "$(date +"%Y-%m-%d %H:%M:%S") Want full" >> ~/report