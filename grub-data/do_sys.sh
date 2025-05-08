#!/bin/bash

echo Updating USB ...

./mount_grub.sh
sudo ./cp_grub.sh
sudo ./cp_store.sh
sudo ./cp_sys.sh
sync
./umount_grub.sh

echo Done update.

# EOF
