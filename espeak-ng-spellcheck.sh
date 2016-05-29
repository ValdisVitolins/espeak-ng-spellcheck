#!/bin/bash

function s {
  sdir=$(pwd)
  export ESPEAK_DATA_PATH=~/code/espeak-ng/
  #echo $ESPEAK_DATA_PATH
  export LD_LIBRARY_PATH=~/code/espeak-ng/src/
  #echo $LD_LIBRARY_PATH
  make -C $ESPEAK_DATA_PATH -f $ESPEAK_DATA_PATH/Makefile >/dev/null
  cd ${ESPEAK_DATA_PATH}dictsource
  ../src/espeak-ng --compile-debug=lv
  cd $sdir
  echo "--------------"
}

# Handle previous spelling file
if [ -f spelling.tmp ]; then
  read -r -p "Move spelling.tmp to prev [y/N]? " response
  response=${response,,} # tolower
  if [[ $response =~ ^(y|yes) ]]; then
  echo "y"
    mv spelling.tmp spelling.prev.tmp
  fi
fi

echo "compiling espeak-ng..."
s;

echo "runnning espeak-ng spelling..."
~/code/espeak-ng/src/espeak-ng -vlv -x -q -f lv-words.txt > spelling.tmp

echo "making spelling diff file..."
diff -y --suppress-common-lines spelling.prev.tmp spelling.tmp > spelling-diff.tmp
meld spelling.prev.tmp spelling.tmp 2>/dev/null &

echo "running espeak-ng... rules"
~/code/espeak-ng/src/espeak-ng -vlv -X -q -f lv-words.txt > rule-results.tmp

echo "running winning-rule-lines.py..."
cat rule-results.tmp | winning-rule-lines.py > winning-rule-lines.tmp

echo "aggregating winning results for winning lines..."
cat winning-rule-lines.tmp | awk '{print $1}' | sort -nu > winning-lines.tmp
cat winning-rule-lines.tmp | awk '{print $1}' | sort| uniq -c| sort -nr > winning-lines-count.tmp
echo "" > lines.tmp
linecount=$(wc -l ~/code/espeak-ng/dictsource/lv_rules |awk '{print $1}')
for i in $(seq 1 $linecount); do
  echo $i >> lines.tmp
done

echo "making list of unused lines file..."
diff -y lines.tmp winning-lines.tmp|awk '{print $1"\t"$2}' > unused-lines.tmp

echo "Done"

