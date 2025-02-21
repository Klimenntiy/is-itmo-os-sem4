#!/bin/bash

echo "1-nano, 2-vi, 3-links, 4-exit"

read command
if [ "$command" -eq "1" ]; then
	nano
fi
if [ "$command" -eq "2" ]; then
	vi
fi
if [ "$command" -eq "3" ]; then
	links
fi