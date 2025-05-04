#!/usr/bin/bash

current_date=$(date +%Y-%m-%d)
backup_root="$(dirname "$(realpath "$0")")"   
source_dir="$backup_root/source"              
backup_dir="$backup_root/Backup-$current_date"  
backup_report="$backup_root/backup-report"    

if [ ! -d "$source_dir" ]; then
    echo "[ERROR] Исходная папка не найдена: $source_dir"
    exit 1
fi

if [ ! -d "$backup_dir" ]; then
    mkdir -p "$backup_dir"
    echo "Создан новый каталог бекапа: $backup_dir на $(date)" >>"$backup_report"

    cp "$source_dir"/* "$backup_dir/"
    echo "Копированы файлы:" >>"$backup_report"
    for file in "$backup_dir"/*; do
        echo "$file" >>"$backup_report"
    done
else
    for file in "$source_dir"/*; do
        file_name=$(basename "$file")
        backup_file="$backup_dir/$file_name"

        if [ ! -f "$backup_file" ]; then
            cp "$file" "$backup_dir/"
            echo "Копирован новый файл: $file_name" >>"$backup_report"
        else
            if [ "$(stat -c%s "$file")" -ne "$(stat -c%s "$backup_file")" ]; then
                mv "$backup_file" "$backup_file.$current_date"
                cp "$file" "$backup_dir/"
                echo "Обновлен файл: $file_name (старую версию переименовали в $backup_file.$current_date и скопировали новую)" >>"$backup_report"
            fi
        fi
    done
    echo "Изменения в существующем каталоге бекапа: $backup_dir на $(date)" >>"$backup_report"
fi
