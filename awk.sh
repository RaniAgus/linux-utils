#!/bin/bash

print_previous_lines() {
  FILE=${1:?}
  PATTERN=${2:1}
  N=${3:?}

  tac $FILE | awk '/'$PATTERN'/\
    {\
      for (i='$N';i;i--) {\
        print;\
        getline;\
      }\
      print "==============================================================\n"\
    }' | tac
}
