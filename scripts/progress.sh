#!/bin/bash

#TESTFILE=comlin64.iso.part

# Give time for initial operation
echo
while true ; do
    stat --printf "%s         \r" "$1"
    sleep 1
    # Gone?
    if [ ! -f "$1" ] ; then
        #echo no test file
        break
    fi
done
#echo done testfile progress $1
echo

