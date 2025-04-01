#!/bin/bash

# This way the not number turns into false
ERRX=$1
#echo err val: \'"$1"\' val: $((ERRX))

if [  $(($ERRX)) -ne 0 ] ; then
    if [  $(($ERRX)) -eq 1 ] ; then
        echo "set 1"
    else
        echo "set x"
    fi
else
    echo "NOT set"
fi

if [  "$ERRX" == "0" ] ; then
  echo "Unset"
else
    echo "Set"
fi
