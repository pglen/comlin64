#!/bin/bash
# shellcheck disable=SC1091,SC2093

. grub_conf justvars

# Any ISO files?
if [ ! -f "$ISOFILE" ] ; then
    echo ISO file \'"$ISOFILE"\' not found.
    exit 1
fi

MMM=$(mount | grep "$GRUBDATA")
if [ "$MMM" == "" ] ; then
    echo \'"$GRUBDATA"\' not mounted.
    exit 1
fi

sudo mount -o loop "$ISOFILE" "$ISOMNT" >/dev/null 2>&1
ERRX=$?
if [ "$ERRX" != "0" ] ; then
    echo Error on mounting ISO file \'"$ISOFILE"\'
    exit 1
fi

if [ ! -f "$ISOMNT"/etc/COMLINUX_VERSION ] ; then
    echo ISO file \'"$ISOFILE"\' not mounted or bad ISO file.
    exit 1
fi

shopt -s dotglob

sudo rsync -rau  \
            --info=progress2 \
            "$ISOMNT"/* "$GRUBDATA"
shopt -u dotglob

# CDROM lost setud bits ... restore

ALLFILES="\
/usr/bin/chfn \
/usr/bin/chsh \
/bin/chvt \
/bin/fusermount3 \
/bin/mount \
/usr/bin/newgrp \
/bin/su \
/usr/bin/sudo \
/bin/umount \
/usr/bin/at \
/usr/bin/chfn \
/usr/bin/chsh \
/usr/bin/chvt \
/bin/fusermount \
/bin/fusermount3 \
/usr/bin/gpasswd \
/usr/bin/mount \
/usr/bin/newgrp \
/usr/bin/passwd \
/usr/bin/pkexec \
/usr/bin/su \
/usr/bin/sudo \
/usr/bin/umount \
/usr/lib/dbus-1.0/dbus-daemon-launch-helper \
/usr/libexec/polkit-agent-helper-1 \
/usr/sbin/pppd \
"
#echo $ALLFILES

for AA in $ALLFILES ; do
    #echo $ROOTFS$AA
    sudo chmod u+s "$GRUBDATA"
done

echo Flush
sync
sudo umount "$ISOMNT"
echo Done copying ISO
# EOF
