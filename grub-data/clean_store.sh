#!/bin/bash

set +x

. grub_conf justvars

echo -n "Cleaning USB storage ... "

./mount_grub.sh

sudo rm -rf /mnt/data/tmp/*
sudo rm -rf /mnt/data/var/tmp/*
sudo rm -rf /mnt/data/var/log/*
sudo rm -rf /mnt/store/fs/*
sudo rm -rf /mnt/store/lost+found/
sync

./umount_grub.sh

echo OK

# EOF
