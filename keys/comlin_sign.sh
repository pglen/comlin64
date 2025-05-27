#!/bin/bash

function helpme {
      echo -e "Usage: $(basename $0) [ -v ] filename"
      echo "Sign file"
      echo " options:"
      echo "       -v           -- verbose (may add more -v options)"
      echo "       -h           -- help (this screen)"
      echo "       -d   level   -- debug level (0-10)"
      echo "       -k   key     -- private key filename"
      echo "       -q           -- quiet, only report errors"
      echo "       -f           -- force re-sign"
}

TMPFILE1=$(mktemp)
QUIET=0 ; DEBUG=0 ; FORCE=0

while getopts "vhk:d:qf" opt;
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
        PRIKEY_REAL=$KEYF
        ;;
    d)
      DEBUG=$OPTARG
      ;;
    f)
      FORCE=1
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
    echo Use: sign filename
    exit 0
fi

if [ ! -f "$1" ] ; then
    if [ ! -d "$1" ] ; then
        echo No file: "$1"
    fi
    exit 1
fi

if [ $((VERBOSE)) -gt 0 ] ; then
    echo "Signing: $1"
fi

SD=$(realpath $0) ; DN=$(dirname $SD)
. $DN/keyparms.sh

if [ "$PRIKEY_REAL" == "" ] ; then PRIKEY_REAL=$DN/$PRIKEY; fi

mkdir -p $DN/$SIGDIR || echo cannot create $SIGDIR

RFILE=$(realpath "$1")

#echo  $RFILE
encode_fname "$RFILE"
#echo  $SIGFILE
#decode_fname "$SIGFILE"
#echo  $REALFILE

SS=$(echo "$SIGFILE" | cksum)
SSS=$DN/"$SIGDIR"/${SS::3}

# TEST
#SSS=$DN/"$SIGDIR"/00

if [ $((VERBOSE)) -gt 2 ] ; then
    echo Using file: $SSS
fi
declare -i OFFSET=0
lookup $SIGFILE; ERR=$?

#echo KEYX: $KEYX
#echo SIGFILE: $SIGFILE
#echo OFFSET: $OFFSET

if [  "$ERR" != "0" ] ; then
    #echo OFFSET: $OFFSET

    if [  "$FORCE" != "0" ] ; then
        if [ $((VERBOSE)) -gt 0 ] ; then
            echo "Force signing: $1"
        fi
        echo "DOR" | dd of=$SSS bs=1 \
                    seek=$OFFSET count=4 conv=notrunc 2>/dev/null
    else
        echo Already signed "(in ${SS::3})": "$1"
        exit 2
    fi
fi

if [ $((VERBOSE)) -gt 1 ] ; then
    echo PRIKEY_REAL $PRIKEY_REAL
fi

openssl dgst -sha256 -sign $PRIKEY_REAL "$1" | xxd -p > $TMPFILE1

if [ ! -f $SSS ] ; then
    touch $SSS
fi

# Save signature
echo "BOR" >> $SSS
echo $SIGFILE >> $SSS
cat $TMPFILE1 >> $SSS

secdel  $TMPFILE1

# EOF
