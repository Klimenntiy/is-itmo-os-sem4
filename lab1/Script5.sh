#!/bin/bash

touch info.log
awk '{
  if ($3 == "INFO")
    print $0
  }' /var/log/installer/syslog >info.log