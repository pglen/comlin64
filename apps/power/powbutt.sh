#!/bin/bash

# shellcheck disable=SC2004,SC2009,SC2068,SC2002,SC1091

#. /sbin/preinit.sh
#. /sbin/terminit.sh

VV="0"

while getopts 'v' opt; do
  case "$opt" in
    v)
        VV="1"
        echo "prog: '$0' args: '$*'"
        shift
        ;;
    #?)
    #    echo -e "Invalid command option."
    #    echo -e "Usage: $(basename $0) [ -v ]"
    #    exit 1
    #    ;;
   esac
done

# if XFCE session is running, let it do its thing
XXX=$(pgrep xfce4-session)
if [ "$XXX" != "" ] ; then
    exit 0
fi

shut_down() {

    chvt 1
    #clear
    echo "-P" >/var/tmp/.shutdowncmd
    sync
    #echo -n "Shutting down GUI ... "
    #XXX=$(ps xa | grep Xorg  | grep -v grep | head -1 | awk '{print $1 }')
    XXX=$(pgrep Xorg)
    if [ "$XXX" != "" ] ; then
        kill "$XXX"
    else
        echo "Press without GUI"
    fi
    #echo "Shut down Xorg."
}

if [ "$1" == "button/power" ] ; then
    #echo "power button pressed"
    logger "Power button pressed"
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
