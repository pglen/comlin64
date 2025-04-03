#!/bin/bash

. grub_conf justvars

MMM=$(mount | grep $CONFIG_DRIVE)
if [ "$MMM" != "" ] ; then
    #echo "Device is mounted, exiting."
    exit 1
fi

AA=$(echo $GRUBROOT | grep loop)
if [ "$AA" != "" ] ; then
    LLL=$(losetup | grep ".img")
    if [ "$LLL" == "" ] ; then
        echo Not a valid loop device
        exit 1
    fi
else
    if [ ! -b "$CONFIG_DRIVE" ] ; then
        echo Not a valid block device
        exit 1
    fi
fi

mountifnot "" "$GRUBROOTp"4 /mnt/store
mountifnot "" "$GRUBROOTp"3 /mnt/data
mountifnot "" "$GRUBROOTp"2 /mnt/guest
mountifnot "" "$GRUBROOTp"1 /mnt/guest/boot/efi
mountifnot "-t efivarfs" "efivarfs" /mnt/guest/sys/firmware/efi/efivars

mountifnot "--bind" /proc /mnt/guest/proc
mountifnot "--bind" /dev /mnt/guest/dev
mountifnot "--bind" /dev/pts /mnt/guest/dev/pts
mountifnot "--bind" /sys /mnt/guest/sys

# EOF
