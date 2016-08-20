#!/usr/bin/python3
# encoding: utf-8
import sys

rlineno=0    # rule line number
ulineno=0    # unused line number

rfile = open ('lv_rules_2016-08-15_21-19')
ufile = open ('unused-lines.txt')

uline = ufile.readline()
while uline:
  uline = ufile.readline()
  try:
    unused = uline.split()[1]
  except IndexError:
    unused = ""
  if unused == "<":
    ulineno = int((uline.split()[0]).replace("<","0"))
    rline = rfile.readline()
    while rline:
      rlineno += 1
      if not rline : break
      if rlineno >= ulineno: 
        sys.stdout.write (str(ulineno) + ": " + rline )
        break
      else:
        rline = rfile.readline()
rfile.close()
ufile.close()
