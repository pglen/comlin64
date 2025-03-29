#!/bin/bash

if [ -f /var/tmp/currexec ] ; then
    read -r XXXX < /var/tmp/currexec
    #echo "Executing: $XXXX"
    $XXXX
fi

# EOF
