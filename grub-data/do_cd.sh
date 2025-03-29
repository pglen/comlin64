#!/bin/bash

./mount_grub.sh
./cp_grub.sh
./cp_iso.sh
sync
./umount_grub.sh

# EOF
