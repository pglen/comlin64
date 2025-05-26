#!/bin/bash

# Test key pair signature

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

SD=$(realpath $0) ; DN=$(dirname $SD)
. $DN/keyparms.sh

RFILE=$(realpath $1)
encode_fname $RFILE

if [ ! -f $SIGFILE ] ; then
    echo Not signed
    exit 2
fi

echo -n "$RFILE: --  "
cat $SIGFILE | xxd -r -p > tmp
openssl dgst -sha256 -verify $PUBKEY -signature tmp $RFILE
rm tmp

# EOF
