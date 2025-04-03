#!/bin/bash

# Encrypt key pair signature

. keyparms.sh

TMPNAME=$(basename $PRIKEY .pem)_enc.pem
#echo -in $PRIKEY -out $TMPNAME
openssl pkcs8 -topk8 -scrypt -in $PRIKEY -out $TMPNAME

if [ "$?" != "0" ] ; then
    echo No key operation carried out
else
    rm $PRIKEY
    mv $TMPNAME $PRIKEY
fi

# EOF
