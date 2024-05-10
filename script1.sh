#!/bin/bash


# Отримуємо поточну дату
current_date=$(date +'%Y/%m/%d')

# Перевірка існування папки /var/SOMA та створення її, якщо вона не існує
if [ ! -d "/var/SOMA/$current_date" ]; then
    mkdir -p /var/SOMA/$current_date
fi

# Перевірка, чи існує папка SOMA в /data
if [ ! -d "/data/SOMA/$current_date" ]; then
    mkdir -p /data/SOMA/$current_date
fi

#Створюю файл логів та помилок в /var/SOMA/...
script_log="/var/SOMA/$current_date/script.log"
error_log="/var/SOMA/$current_date/error.log"
result_file="/data/SOMA/$current_date/result_file.txt"

# Записуємо час запуску скрипта в файл script.log
echo "Script started at $(date)" >> "$script_log"

#Перебираю шляхи та відокремлюю їх одна від одної 

dir=$(IFS=':' read -ra paths <<< "$PATH"
for path in "${paths[@]}"; do
    echo "Directory: $path"
done)

# Цикл для перевірки існування директорій та їх вмісту
for dir in $directories; do 
    if [[ -d "$dir" ]]; then 
        # Підрахунок кількості файлів в директорії 
        files_count=$(find "$dir" -type f | wc -l)
        echo "Directory: $dir, File count: $files_count" >> "$result_file"
    else
        echo "Directory $dir does not exist" >> "$error_log"
    fi 
done 

echo "Script finished at $(date)" >> "$result_file"

# Знаходимо шляхи до файлів з результатами виконання скрипта
#result_files=$(find . -name "result*.txt")

# Перебираємо кожен файл з результатами
for file in $result_files; do
    # Знаходимо директорію з PATH у файлі
    path_directory=$(grep -R "/usr/sbin" "$file" | awk -F ':' '{print $1}')
    # Якщо директорія знайдена, виводимо інформацію
    if [ -n "$path_directory" ]; then
        echo "Directory $dir found in file: $path_directory" >> "$result_file"
    fi
done

# Записуємо час завершення виконання скрипта в файл результату
#echo "Script finished at $(date)" >> "$result_file"


# Записуємо час завершення скрипта в файл script.log
echo "Script finished at $(date)" >> "$script_log"

#В .bashrc добавив команду bash /home/dnscxrbl/work/script/SOMA щоб скріпт автоматично запускався під час запуску терміналу

#В crontab -e добавив 5 * * * * /home/dnscxrbl/work/script/SOMA/script1.sh щоб скріпт спрацьовув кожну 5 хвилину

#Знаходимо файли у папці 2024 з розширенням .txt, далі вираховуємо які з них старші 3х днів, далі запускаємо цикл,який буде видаляти розширення .txt і архівувати ці файли з їх назвою  

#find /home/dnscxrbl/2024 -type f -name "*.txt" -mtime +3 -exec sh -c 'for file; do tar -czvf "${file%.txt}.tar.gz" "$file"; done' _ {} +


