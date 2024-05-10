#!/bin/bash -eu

# Получаем текущую дату
current_date=$(date +'%Y/%m/%d')

# Проверка существования папки /var/SOMA и создание её, если она не существует
if [ ! -d "/var/SOMA/$current_date" ]; then
    mkdir -p "/var/SOMA/$current_date"
fi

# Проверка существования папки SOMA в /data
if [ ! -d "/data/SOMA/$current_date" ]; then
    mkdir -p "/data/SOMA/$current_date"
fi

# Создаю файлы логов и ошибок в /var/SOMA/...
script_log="/var/SOMA/$current_date/script.log"
error_log="/var/SOMA/$current_date/error.log"
result_file="/data/SOMA/$current_date/result_file.txt"

# Записываем время запуска скрипта в файл script.log
echo "Script started at $(date)" >> "$script_log"

# Разделение путей и запись их в массив directories
IFS=':' read -ra directories <<< "$PATH"
for dir in "${directories[@]}"; do
    echo "Directory: $dir"
done

# Цикл для проверки существования директорий и их содержимого
for dir in "${directories[@]}"; do
    if [[ -d "$dir" ]]; then
        # Подсчет количества файлов в директории
        files_count=$(find "$dir" -type f | wc -l)
        echo "Directory: $dir, File count: $files_count" >> "$result_file"
    else
        echo "Directory $dir does not exist" >> "$error_log"
    fi
done

# Поиск файлов с результатами в /data/SOMA и запись их в переменную result_files
result_files=$(find "/data/SOMA/$current_date" -name "result*.txt")

# Перебор каждого файла с результатами
for file in $result_files; do
    # Поиск директории с PATH в файле
    path_directory=$(grep -R "$dir" "$file" | awk -F ':' '{print $1}')
    # Если директория найдена, выводим информацию
    if [ -n "$path_directory" ]; then
        echo "Directory $dir found in file: $path_directory" >> "$result_file"
    fi
done

# Записываем время завершения выполнения скрипта в файл результатов
echo "Script finished at $(date)" >> "$script_log"
#