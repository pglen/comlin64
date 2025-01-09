#!/bin/bash

examine() {
    #echo "examine:" path: $1 file: $2 event: $3
    echo Changed: $1$2
    cat $1$2
}

# Temporary SHELL
tmpshell() {
    if [ "$1" == "" ] ; then
       export PS1="tmpshell $"
       export PS2="(2) tmpshell $"
    else
       export PS1=$1
       export PS2="$1"
    fi
    setsid -c -w /bin/bash
}

# EOF