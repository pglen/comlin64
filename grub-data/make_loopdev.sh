#!/bin/bash
# shellcheck disable=SC1091,SC2093

. grub_conf justvars

if [ ! -f $IMGFILE ] ; then
    echo "Makeing loop file $IMGFILE"
    dd status=progress if=/dev/zero of=$IMGFILE bs=M count=32000
fi

LL=$(losetup | grep $IMGFILE | awk '{print $1}')
if [ "$LL" != "" ] ; then
    #echo Loop device already exists: $LL
    echo $LL
    exit
fi
losetup /dev/loop0 $IMGFILE
LL=$(losetup | grep $IMGFILE | awk '{print $1}')
echo $LL

# EOF