#!/usr/bin/bash

current_date=$(date +%Y-%m-%d)
backup_root="$(dirname "$(realpath "$0")")"   
source_dir="$backup_root/source"              
backup_dir="$backup_root/Backup-$current_date"  
backup_report="$backup_root/backup-report"    

if [ ! -d "$source_dir" ]; then
    echo "[ERROR] Source directory not found: $source_dir"
    exit 1
fi

if [ ! -d "$backup_dir" ]; then
    mkdir -p "$backup_dir"
    echo "New backup directory created: $backup_dir at $(date)" >> "$backup_report"

    cp -r "$source_dir"/* "$backup_dir/" 2>/dev/null
    echo "Copied files:" >> "$backup_report"
    for file in "$backup_dir"/*; do
        [ -e "$file" ] && echo "$file" >> "$backup_report"
    done
else
    for file in "$source_dir"/*; do
        file_name=$(basename "$file")
        backup_file="$backup_dir/$file_name"

        if [ ! -e "$backup_file" ]; then
            cp -r "$file" "$backup_dir/"
            echo "New file copied: $file_name" >> "$backup_report"
        else
            if [ "$(stat -c%s "$file" 2>/dev/null)" -ne "$(stat -c%s "$backup_file" 2>/dev/null)" ]; then
                mv "$backup_file" "$backup_file.$current_date"
                cp -r "$file" "$backup_dir/"
                echo "Updated file: $file_name (old version renamed to $backup_file.$current_date)" >> "$backup_report"
            fi
        fi
    done
    echo "Changes in existing backup directory: $backup_dir at $(date)" >> "$backup_report"
fi