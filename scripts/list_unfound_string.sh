#!/bin/bash

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    echo "Usage: $0 <sub-folder> <string> [tail]"
    exit 1
fi

sub_folder=$1
search_string=$2
tail_option=$3

if [ ! -d "$sub_folder" ]; then
    echo "Error : subfolder '$sub_folder' doesn't exist !"
    exit 1
fi

results=$(grep -irRL "$search_string" $sub_folder | sed "s|^$sub_folder/||")

if [ "$tail_option" == "tail" ]; then
    echo "$results" | while IFS= read -r file; do
        echo "==> $file <=="
        tail -n3 "$sub_folder/$file"
    done
else
    echo "$results"
fi