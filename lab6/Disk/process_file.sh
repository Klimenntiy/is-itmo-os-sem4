#!/bin/bash
FILE=$1
TMP=$(mktemp)

while read -r num; do
    echo $((num * 2)) >> "$TMP"
done < "$FILE"

cat "$TMP" >> "$FILE"
rm "$TMP"
