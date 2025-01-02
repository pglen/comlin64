#!/bin/bash
IFS=$'\n'
FF=$(cat /etc/modules)
for AA in $FF ; do
    #echo "${AA:0:1}"
    if [ "${AA:0:1}" != "#" ] ; then
        modprobe $AA
    fi
done

# EOF
