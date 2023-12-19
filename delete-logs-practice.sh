#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"

Source_Dir="sample"

if [ ! -d "$Source_Dir" ]
then
    echo -e "$R ERROR: Source directory doesn't exist.$N"
fi

File_to_delete=$(find "$Source_Dir" -type f -mtime +14 -name '*.logs')

while IFS= read -r line
do
    echo "Deleting files: $line"
done <<< $File_to_delete
