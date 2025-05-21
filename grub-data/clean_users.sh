#!/bin/bash

set +x

. grub_conf justvars

echo -n "Cleaning USB user data ... "

./mount_grub.sh

sudo rm -rf /mnt/data/root/
sudo rm -rf /mnt/data/home/*
sync

./umount_grub.sh

echo OK

# EOF
