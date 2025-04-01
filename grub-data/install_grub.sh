#!/bin/bash

. grub_conf

#su - root -c "chroot $INSTARG grub-install"
#--target=x86_64-efi --bootloader-id=grub_uefi --recheck

#sudo chroot $INSTARG grub-mkdevicemap
sudo chroot $INSTARG grub-install  --no-nvram

# grub-install mounts a bunch of stuff ... undo it

sudo umount $INSTARG/dev/pts
sudo umount $INSTARG/dev
#sudo umount $INSTARG/sys
sudo umount $INSTARG/proc

# EOF
