#!/bin/bash

mkdir -p "test_dir/dir with space/subdir?"
cd test_dir || exit 1

touch "file with spaces.txt"

touch "file\,name.txt" "file\&name.txt" "file\|name.txt" "file\#name.txt" "file\'name.txt" "file\"name.txt"
touch "--file.txt" "file$name.txt" "file[path].txt" "file{brace}.txt"

printf "test" > "file"$'\n'"name.txt"

mkdir -p "dir-with-dash"
mkdir -p "space dir"
mkdir -p "another dir/with subdir?"

echo "[INFO] Test files and directories created in ./test_dir/"
