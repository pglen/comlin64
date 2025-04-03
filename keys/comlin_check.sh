#!/bin/bash

# Test key pair signature

. keyparms.sh

if [ "$1" == "" ] ; then
    echo Use: check.sh filename
    exit 0
fi

if [ ! -f $1 ] ; then
    if [ ! -d $1 ] ; then
        echo No file: $1
    fi
    exit 1
fi

RFILE=$(realpath $1)
encode_fname $RFILE

if [ ! -f $SIGFILE ] ; then
    echo Not signed
    exit 2
fi

echo -n "$RFILE: --  "
openssl dgst -sha256 -verify $PUBKEY -signature $SIGFILE $RFILE

# EOF
