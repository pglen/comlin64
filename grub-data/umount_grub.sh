#!/bin/bash

. grub_conf justvars
. grub_funct

umountifnot /mnt/data
umountifnot /mnt/store

umountifnot /mnt/guest/boot/efi
umountifnot /mnt/guest/sys/firmware/efi/efivars
umountifnot /mnt/guest/proc
umountifnot /mnt/guest/sys
umountifnot /mnt/guest/dev/pts
umountifnot /mnt/guest/dev

umountifnot /mnt/guest
umountifnot /mnt/store

umountifnot /mnt/store

# Just to make sure

umountifnot "$CONFIG_DRIVE"1
umountifnot "$CONFIG_DRIVE"2
umountifnot "$CONFIG_DRIVE"3
umountifnot "$CONFIG_DRIVE"4

# EOF
