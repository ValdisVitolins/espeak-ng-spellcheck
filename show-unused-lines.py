#!/usr/bin/python3
# encoding: utf-8
import sys

rulefile = sys.argv[1] 
ulinfile = sys.argv[2] 

rulefile = open (rulefile)
ulinfile = open (ulinfile)

rlineno=0    # rule line number
ulineno=0    # unused line number

uline = ulinfile.readline()
while uline:
  uline = ulinfile.readline()
  try:
    unused = uline.split()[1]
  except IndexError:
    unused = ""
  if unused == "<":
    ulineno = int((uline.split()[0]).replace("<","0"))
    rline = rulefile.readline()
    while rline:
      rlineno += 1
      if not rline : break
      if rlineno >= ulineno: 
        sys.stdout.write (str(ulineno) + ": " + rline )
        break
      else:
        rline = rulefile.readline()
rulefile.close()
ulinfile.close()
