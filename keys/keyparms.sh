#!/bin/bash

PRIKEY=comlin64_private.pem
PUBKEY=comlin64_public.pem
SIGDIR=./signatures
EXTX=.sig

encode_fname() {

    if [ $((VERBOSE)) -gt 0 ] ;  then echo "org:" $1; fi
    SIGFILE=$(echo $1 | sed "s/-/\\\\2D/")
    if [ $((VERBOSE)) -gt 1 ] ;  then echo "esc:" $SIGFILE; fi
    SIGFILE=$(echo $SIGFILE | tr / -)
    SIGFILE=$SIGDIR/${SIGFILE:1}$EXTX
    if [ $((VERBOSE)) -gt 0 ] ;  then echo "enc:" $SIGFILE; fi
}

decode_fname() {
    REALFILE=$(echo $1 | tr - /)
    LENX=$((${#REALFILE} - ${#SIGDIR} - ${#EXTX}))
    if [ $((VERBOSE)) -gt 2 ] ;  then echo "lenx:" $LENX; fi
    REALFILE=${REALFILE:${#SIGDIR}:$LENX}
    if [ $((VERBOSE)) -gt 1 ] ;  then echo "usc:" $REALFILE; fi
    REALFILE=$(echo $REALFILE | sed "s/\\\\2D/-/")
    if [ $((VERBOSE)) -gt 0 ] ;  then echo "dec:" $REALFILE; fi
}

# EOF


