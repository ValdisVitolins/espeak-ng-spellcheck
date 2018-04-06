#!/bin/bash
lang="ar"
no="1"
log="${lang}-log.txt"
rm $log 2>/dev/null
while IFS='' read -r line || [[ -n "$line" ]]; do
    printf "$(echo "$line"|tr "\r" "\t")" >> $log
    unbuffer espeak-ng -x -q -vmb-${lang}${no} "$line" >> $log 2>&1
done < "${lang}-words.txt"
