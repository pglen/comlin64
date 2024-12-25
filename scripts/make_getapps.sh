 #!/bin/bash

. ./config_build nocheck
. "$SCRIPTS"/misc/lib/lib_fail

echo
echo "-------------------------------------"
echo " Get apps into new image "
echo "-------------------------------------"
echo

if [ ! -f $KEYGET ] ; then
    echo "Please exceute 'make apps' first."
    exit 1;
fi

echo -n "Copying APPS ... "

mkdir -p $ROOTFS/bin

cp $APPDIR/keyget/keyget $ROOTFS/bin
cp $APPDIR/reboot/linux_reboot $ROOTFS/bin
cp $APPDIR/reboot/linux_poweroff $ROOTFS/bin

echo OK

# EOF
