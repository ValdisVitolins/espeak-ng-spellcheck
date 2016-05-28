#!/usr/bin/python3
# encoding: utf-8
import sys
import re

weight = 0
lineNo = 0
prevLineNo = 0
prevWeight = 0

for line in sys.stdin:
    #sys.stderr.write("! " + line)
    if re.search("^Translate|^$", line):  # or line == "\n":  # if next letter or word is started
      if prevLineNo > 0:  # print out result for previous letter
         sys.stdout.write (str(prevLineNo) + "\t" + str(prevWeight) + "\n")  
      prevWeight = 0
      prevLineNo = 0
    else:
      res = re.search("^\s*?(\d+)", line)
      if res:
        weight = int(res.group(1))
        #sys.stderr.write(">  weight:" + str(weight) + "\n")
      res = re.search("^\s*?\d+\s+(\d+?):", line)
      if res:
        lineNo = int(res.group(1))
        #sys.stderr.write(">  lineNo:" + str(lineNo) + "\n")
      if weight > prevWeight:
         prevLineNo = lineNo
         prevWeight = weight
      prevLine = line
