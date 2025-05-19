#!/bin/bash
FILE=$1
TMP=$(mktemp)

while read -r num; do
    echo $((num * 2)) >> "$TMP"
done < "$FILE"

mv "$TMP" "$FILE"
