#!/bin/bash

# Test key pair signature

. keyparms.sh

if [ "$1" == "" ] ; then
    echo Use: sign filename
    exit 0
fi

if [ ! -f $1 ] ; then
    if [ ! -d $1 ] ; then
        echo No file: $1
    fi
    exit 1
fi

mkdir -p $SIGDIR || echo cannot create $SIGDIR

RFILE=$(realpath $1)
encode_fname $RFILE

if [  -f $SIGFILE ] ; then
    echo Already signed: $1
    exit 2
fi

openssl dgst -sha256 -sign $PRIKEY -out $SIGFILE $1

# EOF
