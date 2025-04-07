#!/bin/bash
# shellcheck disable=SC1091

# Patching set uid permissions

. config_build nocheck
. "$SCRIPTS"/misc/lib/lib_fail

echo "  Setting SUIDs ..."

if [ "$ROOTFS" == "" ] ; then
    # This would be really bad;
    echo "Empty ROOTFS variable ... exiting."
    exit 1
fi

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
    sudo chmod u+s "$ROOTFS""$AA"
done


