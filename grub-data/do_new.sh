#!/bin/bash

./umount_grub.sh
./mk_part.sh
./mount_grub.sh
./cp_bootdrive.sh
./cp_grub.sh
./do_grub.sh
sync
./umount_grub.sh

# EOF
