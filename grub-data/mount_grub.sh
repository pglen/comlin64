#!/bin/bash

. grub_conf justvars

check_drive ../config_drive

mountifnot "" "$CONFIG_DRIVE"3 /mnt/data
mountifnot "" "$CONFIG_DRIVE"2 /mnt/guest
mountifnot "" "$CONFIG_DRIVE"1 /mnt/guest/boot/efi
mountifnot "-t efivarfs" "efivarfs" /mnt/guest/sys/firmware/efi/efivars

mountifnot "--bind" /proc /mnt/guest/proc
mountifnot "--bind" /dev /mnt/guest/dev
mountifnot "--bind" /dev/pts /mnt/guest/dev/pts
mountifnot "--bind" /sys /mnt/guest/sys

# EOF
