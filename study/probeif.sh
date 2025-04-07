#!/bin/bash

# Load module in not loaded

modprobeif() {

    local ISMOD
    ISMOD=$(lsmod | grep "$1")
    #echo ISMOD: \"$ISMOD\"
    if [ "$ISMOD" == "" ] ; then
       #echo "Loading: $1"
       modprobe "$1" >/dev/null 2>&1
    fi
}

modprobeif psmouse
