#!/bin/bash

set +x

. grub_conf justvars

echo Clean USB storage

./mount_grub.sh

sudo rm -rf /mnt/store/fs/*
sudo rm -rf /mnt/store/lost+found/
sync

./umount_grub.sh

echo Done.

# EOF
