#!/bin/bash
# shellcheck disable=SC1091,SC2093

. grub_conf justvars

LL=$(losetup | grep $IMGFILE | awk '{print $1}')
if [ "$LL" != "" ] ; then
    #echo Loop device already exists: $LL
    echo $LL
    exit
fi
losetup -f $IMGFILE
LL=$(losetup | grep $IMGFILE | awk '{print $1}')
echo $LL

# EOF