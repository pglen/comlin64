#!/bin/bash

# Generate a modern key pair

. keyparms.sh

if [ -f $PRIKEY ] ; then
    echo Key is generated already
    exit 1
fi

openssl genpkey -out $PRIKEY -algorithm EC \
                -pkeyopt ec_paramgen_curve:P-384 \
               -pkeyopt ec_param_enc:named_curve

openssl pkey -in $PRIKEY -outform PEM -pubout -out $PUBKEY

# EOF
