#!/bin/bash

function helpme {
      echo -e "Usage: $(basename $0) [ -v ] filename"
      echo "Check signatures"
      echo " options:"
      echo "       -v           -- verbose (may add more -v options)"
      echo "       -h           -- help (this screen)"
      echo "       -d   level   -- debug level (0-10)"
      echo "       -k   key     -- public key filename"
      echo "       -q           -- quiet, only report mismatches / errors"
}

TMPFILE1=$(mktemp)
TMPFILE2=$(mktemp)
DEBUG=0 ; QUIET=0

while getopts "vhk:d:q" opt;
do
  case "$opt" in
    v)
      VERBOSE=$(($VERBOSE+1))
      ;;
    k)
      KEYF=$OPTARG
      if [ ! -f $KEYF ] ; then
        echo "Cannot find key:" "$KEYF"
        exit 1
       fi
      PUBKEY_REAL=$KEYF
      ;;
    d)
      DEBUG=$OPTARG
      ;;
    q)
      QUIET=1
      ;;
    h)
      helpme
      exit
     ;;
    ?)
        #echo -e "Invalid command option. $1"
        exit 1
      ;;
   esac
done

shift $(($OPTIND - 1))

if [ "$1" == "" ] ; then
    echo Use: check.sh filename
    exit 0
fi

if [ ! -f "$1" ] ; then
        echo No file: "$1"
    exit 1
fi

if [ $((VERBOSE)) -gt 0 ] ; then
    echo "Checking: $1"
fi

SD=$(realpath $0) ; DN=$(dirname $SD)
. $DN/keyparms.sh

if [ "$PUBKEY_REAL" == "" ] ; then PUBKEY_REAL=$DN/$PUBKEY; fi

RFILE=$(realpath "$1")
encode_fname "$RFILE"

SS=$(echo "$SIGFILE" | cksum)
SSS=$DN/"$SIGDIR"/${SS::3}

# TEST
#SSS=$DN/"$SIGDIR"/00

declare -i OFFSET=0
lookup $SIGFILE

if [  "$?" == "0" ] ; then
    echo Not signed: $1
    exit 2
fi

if [ $((VERBOSE)) -gt 1 ] ; then
    echo PUBKEY_REAL $PUBKEY_REAL
fi

echo $KEYX | xxd -r -p > $TMPFILE1
openssl dgst -sha256 -verify $PUBKEY_REAL \
                -signature $TMPFILE1 $RFILE >$TMPFILE2

if [ "$QUIET" != "0" ] ; then
    OOO=$(grep "OK" $TMPFILE2)
    #echo OOO $OOO
    if [ "$OOO" == "" ] ; then
        echo -n "$RFILE: --  "
        cat $TMPFILE2
    fi
else
    echo -n "$RFILE: --  "
    cat $TMPFILE2
fi

secdel $TMPFILE1
secdel $TMPFILE2

# EOF
