#!/bin/bash

read -r USERX < /var/tmp/curruser
read -r DDDD < /var/tmp/currdisp
read -r XXXX < /var/tmp/currexec
#echo "Starting session as USER: '$USERX' DISPLAY: '$DDDD' Exec: $XXXX"
export DISPLAY=$DDDD
su - "$USERX" -c "/usr/bin/xfce4-session --display=$DDDD >.xfce_out 2>.xfce_err"

# EOF
