#!/bin/bash

. grub_conf

# All Files
shopt -s dotglob
sudo rsync -r --times   "../../comlin64-usb-000/." $INSTARG/
shopt -u dotglob

# EOF
