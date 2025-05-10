#!/bin/bash

. grub_conf justvars

echo Checking filesystems on USB ...

./umount_grub.sh

fsck -y "$CONFIG_DRIVE"3
fsck -y "$CONFIG_DRIVE"4
sync

echo Done.

# EOF
