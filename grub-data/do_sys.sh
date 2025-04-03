#!/bin/bash

echo Updating USB ...

./mount_grub.sh
./cp_grub.sh
./cp_store.sh
./cp_sys.sh
sync
./umount_grub.sh

echo Done update.

# EOF
