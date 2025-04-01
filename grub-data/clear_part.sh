#!/bin/bash

# Clear it so it will compress good

. grub_conf justvars

if [ "$1" == "" ] ; then
    echo Must specify a device.
    exit 1
fi

if [ ! -b $1 ] ; then
    echo Must be a block device.
    exit 1
fi

ALREADY=$(mount | grep $1)
if [ "$ALREADY" !=  "" ] ; then
    echo "Please unmount USB first (use: ./umount_grub.sh)"
    exit 1
fi

BS=$((1024*1024))
SSS=$(lsblk -o size -n -b -D "$1")
BBB=$((SSS / BS))

sudo dd status=progress bs="$BS" count="$BBB" if=/dev/zero of="$1"

# EOF
