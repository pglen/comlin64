#!/bin/bash

# Startup for user

echo -n "Starting GUI ... "
pulseaudio --start  >/dev/null 2>&1  &
/usr/bin/startxfce4 -- -keeptty -novtswitch >.xfce_out 2>.xfce_err
echo -e " \033[32;1mOK\033[0m"
chvt 1

# EOF
