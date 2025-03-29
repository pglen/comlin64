#!/bin/bash

# if XFCE session is running, let it do its thing
XXX=$(pgrep xfce4-session)
if [ "$XXX" != "" ] ; then
    exit 0
fi

#echo "prog: '$0' args: '$*'"

shut_down() {
    linux_poweroff -f
}

if [ "$1" == "button/power" ] ; then
    echo "power button pressed"
    logger "power button pressed"
    shut_down
fi

if [ "$1" == "button/lid" ] ; then
    echo "lid operation: $3"
    if [ "$3" == "close" ] ; then
        echo "closing lid"
        logger "lid closed, powering down"
        shut_down
    fi
fi

#logger "3 $0 4 $@"

# EOF
