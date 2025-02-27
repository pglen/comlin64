#!/bin/bash


if [ -f /var/tmp/curruser ] ; then
    read -r USERX < /var/tmp/curruser
fi

if [ -f /var/tmp/currdisp ] ; then
    read -r DDDD < /var/tmp/currdisp
fi

#if [ -f /var/tmp/currexec ] ; then
#    read -r XXXX < /var/tmp/currexec
#fi

#echo "Starting session as USER: '$USERX' DISPLAY: '$DDDD' Exec: $XXXX"
export DISPLAY=$DDDD
su - "$USERX" -c "/usr/bin/xfce4-session --display=$DDDD >.xfce_out 2>.xfce_err"

# EOF
