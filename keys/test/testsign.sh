#!/bin/bash

# Test key pair signature

. keyparms.sh

openssl dgst -sha256 -sign $PRIKEY -out testdata.txt.signature testdata.txt

# EOF
