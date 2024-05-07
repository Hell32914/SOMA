### hello

# title with one dash
## title with two dash
### 3 dash

- test
- foo
- bar

 some code `bash /opt/app/script.sh` the end

```
# Перебираємо кожен файл з результатами
for file in $result_files; do
    # Знаходимо директорію з PATH у файлі
    path_directory=$(grep -R "/usr/sbin" "$file" | awk -F ':' '{print $1}')
    # Якщо директорія знайдена, виводимо інформацію
    if [ -n "$path_directory" ]; then
        echo "Directory /usr/sbin found in file: $path_directory" >> "$result_file"
    fi
done
```
