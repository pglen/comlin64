#!/bin/bash

echo Deleting USB store ...

./mount_grub.sh
sudo rm -rf /mnt/store/fs/*
sync
./umount_grub.sh

echo Done.

# EOF
