#!/bin/bash

# Отримуємо поточну дату
current_date=$(date +'%Y/%m/%d')

# Перевіряємо, чи існує директорія з поточною датою
if [ ! -d "$current_date" ]; then
    mkdir -p "$current_date"
fi

# Створюємо файли script.log та error.log
script_log="$current_date/script.log"
error_log="$current_date/error.log"
touch "$script_log" "$error_log"

# Записуємо час запуску скрипта в файл script.log
echo "Script started at $(date)" > "$script_log"

# Визначаємо ім'я файлу результату виконання скрипта
result_file="$current_date/result-$(date +'%H-%M-%S').txt"

# Записуємо час початку виконання скрипта в файл результату
echo "Script started at $(date)" > "$result_file"

# Знаходимо всі директорії змінної PATH та записуємо їх у зміну directories
directories=$(echo "$PATH" | tr ':' '\n')

# Цикл для перебору всіх директорій
for dir in $directories; do
    # Перевіряємо, чи існує директорія
    if [[ -d "$dir" ]]; then
        # Отримуємо кількість файлів у директорії
        file_count=$(find "$dir" -maxdepth 1 -type f | wc -l)
        echo "Directory: $dir, File count: $file_count" >> "$result_file"
    else
        echo "Directory $dir does not exist" >> "$error_log"
    fi
done

# Знаходимо шляхи до файлів з результатами виконання скрипта
result_files=$(find . -name "result*.txt")

# Перебираємо кожен файл з результатами
for file in $result_files; do
    # Знаходимо директорію з PATH у файлі
    path_directory=$(grep -R "/usr/sbin" "$file" | awk -F ':' '{print $1}')
    # Якщо директорія знайдена, виводимо інформацію
    if [ -n "$path_directory" ]; then
        echo "Directory /usr/sbin found in file: $path_directory" >> "$result_file"
    fi
done

# Записуємо час завершення виконання скрипта в файл результату
echo "Script finished at $(date)" >> "$result_file"


# Записуємо час завершення скрипта в файл script.log
echo "Script finished at $(date)" >> "$script_log"

#В .bashrc добавив команду bash /home/dnscxrbl/work/script/SOMA щоб скріпт автоматично запускався під час запуску терміналу

#В crontab -e добавив 5 * * * * /home/dnscxrbl/work/script/SOMA/script1.sh щоб скріпт спрацьовув кожну 5 хвилину


