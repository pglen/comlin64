#!/bin/bash

read -r USERX < /var/tmp/curruser
read -r DDDD < /var/tmp/currdisp

echo "Starting session as USER: $USERX DISPLAY: $DDDD"
export DISPLAY=$DDDD
su - $USERX -w DISPLAY -c "xfce4-session"

# EOF
