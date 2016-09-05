#!/bin/bash
cdate=$(date +'%F_%H-%M')
# set default language
if [ "$1" == "" ]; then
lang="lv"
else
lang=$1
fi

spellfile="${lang}_spelling_$cdate.txt"

function compile {
  sdir=$(pwd)
  export ESPEAK_DATA_PATH=~/code/espeak-ng/
  #echo $ESPEAK_DATA_PATH
  export LD_LIBRARY_PATH=~/code/espeak-ng/src/
  #echo $LD_LIBRARY_PATH
  make -C $ESPEAK_DATA_PATH -f $ESPEAK_DATA_PATH/Makefile >/dev/null
  cd ${ESPEAK_DATA_PATH}dictsource
  cp ${lang}_rules $sdir/${lang}_rules_$cdate
  cp ${lang}_list $sdir/${lang}_list_$cdate
  ../src/espeak-ng --compile-debug=$lang
  cd $sdir
  echo "--------------"
}

function getprevfile {
  prevfile=$(find -name "${lang}_spelling*.txt" 2>/dev/null|cut -b3-|grep -v diff|tail -n1)
  echo "prevfile: '$prevfile'"
  if [ -z "$prevfile" ]; then
    prevfile="${lang}_spelling.txt"
    touch $prevfile
  fi
}

getprevfile

# Handle previous spelling file
if [ -f "$prevfile" ]; then
  read -r -p "Delete previous spelling file "$prevfile" [y/N]?" response
  response=${response,,} # tolower
  if [[ $response =~ ^(y|yes) ]]; then
    gvfs-trash $prevfile
    getprevfile
  fi
  echo "$prevfile will be used as reference spelling file"
fi

# Start computing
echo "compiling espeak-ng..."
compile

echo "runnning espeak-ng spelling..."
~/code/espeak-ng/src/espeak-ng -v$lang -x -q -f $lang-words.txt > $spellfile 

echo "making spelling diff file..."
diff -y --suppress-common-lines $prevfile $spellfile > ${lang}_spelling-diff.txt
meld $prevfile $spellfile >/dev/null 2>&1 &

echo "running espeak-ng... rules"
~/code/espeak-ng/src/espeak-ng -v$lang -X -q -f $lang-words.txt > ${lang}_rule-results.txt

echo "running winning-rule-lines.py..."
cat ${lang}_rule-results.txt | winning-rule-lines.py > ${lang}_winning-rule-lines.txt

echo "aggregating winning results for winning lines..."
cat ${lang}_winning-rule-lines.txt | awk '{print $1}' | sort -nu > ${lang}_winning-lines.txt
cat ${lang}_winning-rule-lines.txt | awk '{print $1}' | sort| uniq -c| sort -nr > ${lang}_winning-lines-count.txt
echo "" > lines.tmp
linecount=$(wc -l ~/code/espeak-ng/dictsource/${lang}_rules |awk '{print $1}')
for i in $(seq 1 $linecount); do
  echo $i >> lines.tmp
done

echo "making list of unused lines file..."
diff -y lines.tmp ${lang}_winning-lines.txt|awk '{print $1"\t"$2}' > ${lang}_unused-lines.txt

echo "Generating content of unused lines..."
show-unused-lines.py ${lang}_rules_$cdate ${lang}_unused-lines.txt > ${lang}_unused-lines-content.txt
echo "Done"

