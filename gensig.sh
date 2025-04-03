#!/bin/bash

# Generate a modern key pair

PRIKEY=comlin64_private.pem
PUBKEY=comlin64_public.pem

openssl genpkey -out $PRIKEY -algorithm EC \
                -pkeyopt ec_paramgen_curve:P-384 \
               -pkeyopt ec_param_enc:named_curve

openssl pkey -in $PRIKEY -outform PEM -pubout -out $PUBKEY

# EOF
