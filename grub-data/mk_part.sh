#!/bin/bash

# Three partitions ... MSDOS 512M EFI and LINUX EXT[234]
#
# Mon 31.Mar.2025  clean data, so compression has lower size

. grub_conf justvars

ALREADY=$(mount | grep $INSTROOT)
if [ "$ALREADY" !=  "" ] ; then
    echo "Please unmount USB first (use: ./umount_grub.sh)"
    exit 1
fi

# See if we want to clear partition for distributing for dd install
CLEAR=""

while getopts 'ch' opt; do
  #echo "opt:" $opt
  case "$opt" in
    c)
      CLEAR=1
      shift
      ;;

    h )
      echo -e "Usage: $(basename $0) [ -c ]"
      shift
      exit 1
      ;;

   ? )
      exit 1
      ;;
    esac
done

# Format of sfdisk create script:  start, size, type, bootable

echo 'label:mbr' | sudo sfdisk --wipe always $GRUBROOT <<SEOF
,100M,c,*
,256M,U,*
,10G,L,
,,,
SEOF

partx -u /dev/loop0

# See if clear wanted:

if [ "$CLEAR" != "" ] ; then
  ./clear_part.sh "$GRUBROOTp"1
  ./clear_part.sh "$GRUBROOTp"2
  ./clear_part.sh "$GRUBROOTp"3
  ./clear_part.sh "$GRUBROOTp"4
fi

# Purpose of partitions: DOS EFI CODE DATA

sudo mkfs.vfat    "$GRUBROOTp"1
sudo mkfs.vfat    "$GRUBROOTp"2
sudo mkfs.ext4 -F "$GRUBROOTp"3
sudo mkfs.ext4 -F "$GRUBROOTp"4

# EOF
