#!/bin/bash

. grub_conf

# Preserve some info (it is a fat32 FS)
sudo rsync -r --times ../kernel/. $INSTARG/boot/

# EOF
