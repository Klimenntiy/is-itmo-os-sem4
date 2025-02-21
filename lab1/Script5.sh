#!/bin/bash

touch info.log
awk '{
  if ($3 == "info")
    print $0
  }' /var/log/installer/syslog >info.log