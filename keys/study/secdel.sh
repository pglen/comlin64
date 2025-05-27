#!/bin/bash

# Test secure delete

# Secure delete file

secdel() {

    if [ ! -f "$1" ] ; then
        echo "No File: $1" ; return 1
    fi
    SSS=$(stat -c %s "$1")
    dd if=/dev/random bs=1 count=$SSS 2>/dev/null | xxd -p -c 32 > delkey
    #cat $1
    rm -f $1
}

cp testkey delkey

#cat delkey
secdel delkey

# EOF