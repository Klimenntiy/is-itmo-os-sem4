#!/bin/bash

man bash | tr -s ' ' '\n' | grep -E '^[a-zA-Z]{4,}$' | sort | uniq -c | sort -nr | head -3
