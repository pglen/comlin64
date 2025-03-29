#!/bin/bash

#set -v
./mount_grub.sh
./cp_bootdrive.sh
./cp_grub.sh
./umount_grub.sh

# EOF
