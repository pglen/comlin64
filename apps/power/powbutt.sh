#!/bin/bash

# shellcheck disable=SC2004,SC2009,SC2068,SC2002,SC1091

. /sbin/preinit.sh
. /sbin/terminit.sh

# if XFCE session is running, let it do its thing
XXX=$(pgrep xfce4-session)
if [ "$XXX" != "" ] ; then
    exit 0
fi

#echo "prog: '$0' args: '$*'"

shut_down() {

    chvt 1
    #clear
    echo "-P" >/var/tmp/.shutdowncmd
    sync
    echo -n "Shutting down GUI ... "
    #XXX=$(ps xa | grep Xorg  | grep -v grep | head -1 | awk '{print $1 }')
    XXX=$(pgrep Xorg)
    if [ "$XXX" != "" ] ; then
        kill "$XXX"
    fi
    echo "Shut down Xorg."

    #XXX=$(ps xa | grep pypass.py  | grep -v grep)
    #if [ "$XXX" != "" ] ; then
    #    echo "got pypass"
    #    kill
    #fi
    #while : ; do
    #    echo Dropping to shell. Exit to finish shutdown.
    #    tmpshell "Shutdown"
    #
    #    sleep 1
    #done
    #linux_poweroff -f
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
