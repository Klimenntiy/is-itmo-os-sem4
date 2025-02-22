#!/bin/bash
touch emails.lst
grep -E -o -R -i -h "\b\w+@gmail\S*" /etc | tr '\n' ','| sed 's/,$/\n/' >>emails.lst