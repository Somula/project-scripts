#!/bin/bash

R="\e[31m"
G="\e[32m"
N="\e[0m"

SOURCE_DIR="/tmp/shell-scripts-logs"

if [ ! -d "$SOURCE_DIR" ]
then
    echo -e "$R error: Source directory was not found.$N"
fi

FILE_TO_DELETE=$(find $SOURCE_DIR -type f -mtime +14 -name '*.log')

while IFS=read -r line
do
    echo "Deleting files: $line"
done <<< $FILE_TO_DELETE