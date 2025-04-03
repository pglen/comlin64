#!/bin/bash

# Encrypt key pair signature

. keyparms.sh

TMPNAME=$(basename $PRIKEY .pem)_dec.pem
#echo -in $PRIKEY -out $TMPNAME
openssl pkcs8 -in $PRIKEY -out $TMPNAME

if [ "$?" != "0" ] ; then
    echo No key operation carried out
else
    rm $PRIKEY
    mv $TMPNAME $PRIKEY
fi

# EOF
