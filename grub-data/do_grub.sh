#!/bin/bash

./mount_grub.sh
./cp_bootdrive.sh
./cp_grub.sh
./install_grub.sh
sync
./umount_grub.sh

# EOF
