#!/bin/bash

# Encrypt key

SD=$(realpath $0) ; DN=$(dirname $SD)
. $DN/keyparms.sh

# TEST
#PRIKEY=testkey

TMPNAME=$(basename $DN/$PRIKEY .pem)_enc.pem
#echo -in $DN/$PRIKEY -out $TMPNAME
openssl pkcs8 -topk8 -scrypt -in $DN/$PRIKEY -out $TMPNAME

if [ "$?" != "0" ] ; then
    echo No key operation carried out
else
    secdel $DN/$PRIKEY
    mv $TMPNAME $DN/$PRIKEY
fi

# EOF
