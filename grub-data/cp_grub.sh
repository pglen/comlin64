#!/bin/bash

. grub_conf

#  Check if mounted with mount_grub
if [ ! -d $INSTARG/boot/grub ] ; then
    echo Target not mounted.
    exit 1
fi

ERRX=$(grub-script-check data/grub.cfg 2>&1)
if [  "$ERRX" != "" ] ; then
    echo Grub data/grub.cfg syntax error
    exit 1
fi

sudo rsync -r --times data/* $INSTARG/boot/grub

# EOF
