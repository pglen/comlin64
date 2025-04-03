#!/bin/bash

./umount_grub.sh
./mk_part.sh $1
./mount_grub.sh
./do_grub.sh
sync
./umount_grub.sh

# EOF
