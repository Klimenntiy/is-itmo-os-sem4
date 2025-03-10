#!/bin/bash

ps -eo pid,etimes --sort=-etimes | head -n 2 | tail -n 1 | awk '{print $1}'
