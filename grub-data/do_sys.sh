#!/bin/bash

echo Updating USB ...

sudo ./mount_grub.sh
sudo ./cp_grub.sh
sudo ./cp_store.sh
sudo ./cp_sys.sh
sync
sudo ./umount_grub.sh

echo Done update.

# EOF
