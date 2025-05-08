#!/bin/bash
# shellcheck disable=SC1091,SC2093

. grub_conf justvars

# Any SYSTEM files?
if [ ! -d "$TMPSYS" ] ; then
    echo  System  \'"$TMPSYS"\' not found.
    exit 1
fi

MMM=$(mount | grep "$GRUBDATA")
if [ "$MMM" == "" ] ; then
    echo \'"$GRUBDATA"\' not mounted.
    exit 1
fi

if [ ! -f "$TMPSYS"/etc/COMLINUX_VERSION ] ; then
    echo ISO file \'"$TMPSYS"/etc/COMLINUX_VERSION\' not present.
    exit 1
fi

shopt -s dotglob
sudo rsync -rau --delete \
            --info=progress2 \
            $TMPSYS/* "$GRUBDATA"

shopt -u dotglob

echo Flush
sync

#echo Done copying System

# EOF
