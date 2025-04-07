#!/bin/bash

SUBSHELL=0

ctrl_c() {
    echo " CTRL_C caught"
    #exit 0
    echo subshell
    SUBSHELL=1
}

signal_15() {
    echo " Signal 15"
}
signal_0() {
    echo signal 0 ended script $$
}

trap  signal_0 0
trap  ctrl_c 2
trap  signal_15 15

#trap -p

 echo Hello

 while : ;
 do
    if [ $SUBSHELL -ne 0 ] ; then
        SUBSHELL=0
        bash
    fi

    echo -n "Prompt: $SHLVL"
    read AA
    if [ "$AA" != "" ] ; then
        echo $AA
    else
        echo "empty  $SHLVL"
        echo
        if [ $SHLVL -gt 2 ] ; then
            echo backing out
            exit
        fi
    fi

 done

# EOF
