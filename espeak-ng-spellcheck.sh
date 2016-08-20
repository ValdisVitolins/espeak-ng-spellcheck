#!/bin/bash
cdate=$(date +'%F_%H-%M')
spellfile="spelling_$cdate.txt"

function compile {
  sdir=$(pwd)
  export ESPEAK_DATA_PATH=~/code/espeak-ng/
  #echo $ESPEAK_DATA_PATH
  export LD_LIBRARY_PATH=~/code/espeak-ng/src/
  #echo $LD_LIBRARY_PATH
  make -C $ESPEAK_DATA_PATH -f $ESPEAK_DATA_PATH/Makefile >/dev/null
  cd ${ESPEAK_DATA_PATH}dictsource
  cp lv_rules $sdir/lv_rules_$cdate
  cp lv_list $sdir/lv_list_$cdate
  ../src/espeak-ng --compile-debug=lv
  cd $sdir
  echo "--------------"
}

function prevfile {
  prevfile=$(ls spelling*.txt 2>/dev/null|grep -v diff|tail -n1)
  if [ -z "$prevfile" ]; then
    prevfile="spelling.txt"
    touch $prevfile
  fi
}

prevfile

# Handle previous spelling file
if [ -f "$prevfile" ]; then
  read -r -p "Delete previous spelling file "$prevfile" [y/N]?" response
  response=${response,,} # tolower
  if [[ $response =~ ^(y|yes) ]]; then
    gvfs-trash $prevfile
    prevfile
  fi
  echo "$prevfile will be used as reference spelling file"
fi

# Start computing
echo "compiling espeak-ng..."
compile

echo "runnning espeak-ng spelling..."
~/code/espeak-ng/src/espeak-ng -vlv -x -q -f lv-words.txt > $spellfile 

echo "making spelling diff file..."
diff -y --suppress-common-lines $prevfile $spellfile > spelling-diff.txt
meld $prevfile $spellfile >/dev/null 2>&1 &

echo "running espeak-ng... rules"
~/code/espeak-ng/src/espeak-ng -vlv -X -q -f lv-words.txt > rule-results.txt

echo "running winning-rule-lines.py..."
cat rule-results.txt | winning-rule-lines.py > winning-rule-lines.txt

echo "aggregating winning results for winning lines..."
cat winning-rule-lines.txt | awk '{print $1}' | sort -nu > winning-lines.txt
cat winning-rule-lines.txt | awk '{print $1}' | sort| uniq -c| sort -nr > winning-lines-count.txt
echo "" > lines.tmp
linecount=$(wc -l ~/code/espeak-ng/dictsource/lv_rules |awk '{print $1}')
for i in $(seq 1 $linecount); do
  echo $i >> lines.tmp
done

echo "making list of unused lines file..."
diff -y lines.tmp winning-lines.txt|awk '{print $1"\t"$2}' > unused-lines.txt

echo "Done"

