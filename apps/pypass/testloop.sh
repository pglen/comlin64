#!/bin/bash

while : ; do
    ./pypass.py; RET=$?
    # Terminate if got return code from login
    echo "ret: $RET"
    # Was it a signal?
    if [ $RET -gt 127 ] ; then
        continue
    fi
    # Was it a special command?
    if [ "$RET" != "0" ] ; then
        exit $RET
    fi
    # Start system
    read -r DDD < /var/tmp/currdisp
    read -r XXX < /var/tmp/currexec
    read -r UUU < /var/tmp/curruser
    echo "Would start as: '$UUU' exec: '$XXX'  disp: '$DDD' "
    echo "Press enter to continue ..."
    read -r


done

