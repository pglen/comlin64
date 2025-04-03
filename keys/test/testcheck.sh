#!/bin/bash

# Test key pair signature

. keyparms.sh

openssl dgst -sha256 -verify $PUBKEY -signature testdata.txt.signature testdata.txt

# EOF

