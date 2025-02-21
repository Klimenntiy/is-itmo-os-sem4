#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "ERROR"
    exit 1
fi

num1=$1
num2=$2
num3=$3

if [ "$num1" -ge "$num2" ] && [ "$num1" -ge "$num3" ]; then
    echo "MAX_NUM: $num1"
elif [ "$num2" -ge "$num1" ] && [ "$num2" -ge "$num3" ]; then
    echo "MAX_NUM: $num2"
else
    echo "MAX_NUM: $num3"
fi
