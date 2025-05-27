#!/bin/bash

PRIKEY=comlin64_private.pem
PUBKEY=comlin64_public.pem
SIGDIR=signatures
EXTX=.sig

# Convert the filename void of path separators and spaces

encode_fname() {

    SIGFILE="$1"
    if [ $((DEBUG)) -gt 2 ] ;  then echo "org:" "$1"; fi
    SIGFILE=$(echo "$SIGFILE" | sed "s/ /\\\\x20/g")
    if [ $((DEBUG)) -gt 3 ] ;  then echo " spc:" "$SIGFILE"; fi
    SIGFILE=$(echo "$SIGFILE" | sed "s/:/\\\\x3a/g")
    if [ $((DEBUG)) -gt 3 ] ;  then echo " col:" "$SIGFILE"; fi
    SIGFILE=$(echo "$SIGFILE" | sed "s/\//\\\\x5c/g")
    if [ $((DEBUG)) -gt 3 ] ;  then echo " sls:" "$SIGFILE"; fi
    SIGFILE=$SIGFILE$EXTX
    if [ $((DEBUG)) -gt 2 ] ;  then echo "enc:" "$SIGFILE"; fi
}

# Expand the filename back to original

decode_fname() {
    REALFILE="$1"
    if [ $((DEBUG)) -gt 2 ] ;  then echo "org:" "$REALFILE"; fi
    LENX=$((${#REALFILE} - ${#EXTX}))
    if [ $((DEBUG)) -gt 4 ] ;  then echo " lenx:" $LENX; fi
    REALFILE=${REALFILE:0:$LENX}
    if [ $((DEBUG)) -gt 3 ] ;  then echo "unx:" "$REALFILE"; fi
    REALFILE=$(echo "$REALFILE" | sed "s/\\\\x5c/\//g")
    if [ $((DEBUG)) -gt 3 ] ;  then echo "sls:" "$REALFILE"; fi
    REALFILE=$(echo "$REALFILE" | sed "s/\\\\x3a/:/g")
    if [ $((DEBUG)) -gt 3 ] ;  then echo "col:" "$REALFILE"; fi
    REALFILE=$(echo "$REALFILE" | sed "s/\\\\x20/ /g")
    if [ $((DEBUG)) -gt 2 ] ;  then echo "dec:" "$REALFILE"; fi
}

# Deliver key / offset for escaped filename

lookup () {
    local AA BB CC DD EE FF
    WAS=0 ;  KEYX=""

    if [ ! -f $SSS ] ; then
        if [ $((DEBUG)) -gt 0 ] ;  then
            echo "Cannot find signature file $SSS"
        fi
        return 0
    fi
    if [ $((DEBUG)) -gt 1 ] ;  then echo reading: $SSS; fi

    while : ; do
        read -r AA
        if [ "$?" == "" ] ; then
            break
        fi
        if [ "$AA" == "" ] ; then
            break
        fi
        if [ "$AA" != "BOR" ] && [ "$AA" != "DOR" ] ; then
            if [ $((DEBUG)) -gt 1 ] ;  then
                echo Invalid entry $AA skipping at offset $OFFSET
            fi
            while : ;  do
                read -r ZZ ; OFFSET+=${#ZZ}
                if [ $((DEBUG)) -gt 1 ] ;  then echo "skip" $ZZ; fi
                if [ "$ZZ" == "" ] ; then
                    break
                fi
                if [ "$ZZ" == "BOR" ] ; then
                    break
                fi
            done
        fi
        read -r BB
        if [ $((DEBUG)) -gt 2 ] ;  then echo $AA $BB ;  fi

        # Read the four key lines
        KEYX=""
        for RR in $(seq 0 3); do
            read -r CC ; KEYX+=$CC
        done
        if [ "$BB" == "$1" ] && [ "$AA" != "DOR" ] ; then
            WAS=1
            if [ $((DEBUG)) -gt 1 ] ;  then echo $AA $BB; fi
            if [ $((DEBUG)) -gt 2 ] ;  then echo OFFSET $OFFSET; fi
            # Verify
            if [ $((DEBUG)) -gt 3 ] ;  then
                VVV=$(dd if=$SSS skip=$OFFSET bs=1 count=4 2>/dev/null)
                echo Verify: $VVV
            fi
            if [ $((DEBUG)) -gt 4 ] ;  then
                echo KEYX $KEYX
            fi

            break
        fi
        # Calculate next offset, compensate for newlines
        OFFSET+=${#AA}
        OFFSET+=${#BB}
        OFFSET+=${#KEYX}
        OFFSET+=6
    done  < $SSS
    return $WAS
}

# Secure delete file

secdel() {

    if [ ! -f "$1" ] ; then
        echo "No File: $1" ; return 1
    fi
    SSS=$(stat -c %s "$1")
    dd if=/dev/random bs=1 count=$SSS 2>/dev/null | xxd -p -c 32 > $1
    #cat $1
    rm -f $1
}

# EOF


