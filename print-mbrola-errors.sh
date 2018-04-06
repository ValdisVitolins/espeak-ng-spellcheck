#!/bin/bash
v="ar"
egrep ^mbrola ${v}-log.txt |sort|uniq -c|sort -rn > ${v}-errors.txt
while read line; do
    search=$(echo $line|cut -d' '  -f 2-|sed "s/\?/\\\\?/g")
    echo "== $line =="
    egrep "$search" ${v}-log.txt -B3|egrep -v "\-\-|^mbrola"|sort -R|head -n5|sort
done < ${v}-errors.txt
