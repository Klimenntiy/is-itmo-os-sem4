#!/bin/bash

BASE_DIR="$(dirname "$(realpath "$0")")"
SOURCE_DIR="$BASE_DIR/source"

rm -rf "$SOURCE_DIR"
mkdir -p "$SOURCE_DIR"

cd "$SOURCE_DIR" || exit 1

touch "file with spaces.txt"
touch "file#name.txt"
touch "file&name.txt"
touch "file|name.txt"
touch "file,name.txt"
touch "file;name.txt"
touch "file'name.txt"
touch "file\"name.txt"
touch "file[name].txt"
touch "file{name}.txt"
touch "file\$dollar.txt"
touch "file^caret.txt"

touch ./--file.txt  
touch $'file\nname.txt'

mkdir -p "dir with spaces"
mkdir -p "dir-with-dash"
mkdir -p "dir_with_underscores"
mkdir -p "weird#dir"
mkdir -p "space and symbols/next level?"
mkdir -p $'newline\ndir'

touch "dir with spaces/file inside.txt"
touch "space and symbols/next level?/another file.txt"

echo "[INFO] Created test files with special characters in: $SOURCE_DIR"