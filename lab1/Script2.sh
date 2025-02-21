#!/bin/bash
megaStr=""
read str
while [ "$str" != "q" ]; do
	megaStr+="${str}"
	read str
done

echo $megaStr