#!/bin/bash

# Start virtual terminals and a serial port

TERMS="tty2 tty3 tty4 tty5 tty6 ttyS0"

for TT in $TERMS ; do
    #echo $TT
    forever.sh "setsid agetty $TT linux >/dev/null 2>&1" >/dev/null 2>&1 &
done

# EOF
