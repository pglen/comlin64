#!/bin/bash

read -r USERX < /var/tmp/curruser
read -r DDDD < /var/tmp/currdisp
#echo "Starting session as USER: '$USERX' DISPLAY: '$DDDD'"
export DISPLAY=$DDDD
su - "$USERX" -c "/usr/bin/xfce4-session --display=$DDDD >.xfce_out 2>.xfce_err"

# EOF
