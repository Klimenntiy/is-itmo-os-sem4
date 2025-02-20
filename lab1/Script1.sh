#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Использование: $0 число1 число2 число3"
    exit 1
fi

num1=$1
num2=$2
num3=$3

if [ "$num1" -ge "$num2" ] && [ "$num1" -ge "$num3" ]; then
    echo "Наибольшее число: $num1"
elif [ "$num2" -ge "$num1" ] && [ "$num2" -ge "$num3" ]; then
    echo "Наибольшее число: $num2"
else
    echo "Наибольшее число: $num3"
fi
