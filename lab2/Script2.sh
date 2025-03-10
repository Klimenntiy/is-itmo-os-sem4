#!/bin/bash

ps -eo pid,cmd --no-header | grep "^/sbin/" | awk '{print $1}' > output.txt

