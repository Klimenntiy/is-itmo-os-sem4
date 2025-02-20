#!/bin/sh
arr=($1 $2 $3)
let max=arr[1]
for key in "${arr[@]}"
do
	if [ "$max" -lt "$key" ]; then
		 max=$key
	fi
done
echo $max