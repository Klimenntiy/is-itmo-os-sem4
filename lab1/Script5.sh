#!/bin/bash

touch info.log
awk '{
  if ($2 == "INFO")
    print $0
  }' /home/klim/Загрузки/log-copy/anaconda/syslog >info.log