#!/usr/bin/bash


backup_root_dir="$(dirname "$(realpath "$0")")"  


destination_dir="$backup_root_dir/restore"


dirs=$(ls -d "$backup_root_dir"/Backup-* | sort -r)


latest_dir=$(echo "$dirs" | head -n 1)


if [ -z "$latest_dir" ]; then
  echo "[ERROR] Не найдено ни одного бекапа."
  exit 1
fi


mkdir -p "$destination_dir"

echo "[INFO] Восстановление файлов из бекапа: $latest_dir"



find "$latest_dir" -type f ! -regex '.*[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}.*' -exec cp {} "$destination_dir" \;

echo "[INFO] Восстановление завершено из бекапа: $latest_dir"
