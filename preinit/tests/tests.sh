#!/bin/bash
# shellcheck disable=SC2004,SC2009,SC2068,SC2002
# shellcheck disable=SC1091

# This is a tester for the preinit functions. Defining the 'TESTME'
# will prevent the code from executing system functions, instaed
# echo of what would be done.

# Our lib for test. (note: in parent dir for test)

# Set the TESTME variable to non zero if you are in a
# simulation / test environment.

#echo {1..10} ; exit
#UDEVVERSION=$(udevadm --version)
#if [ $UDEVVERSION -lt 140 ]; then
#   UDEV_LOG_PRIO_ARG=--log_priority
#fi

if [ "$1" = "" ] ; then
    echo "Use: $(basename "$0") [all] [1...c]"
    exit
fi

if [ "$1" = "all" ] ; then
    for aa in {1..9} ; do
        ALL+="$aa "
    done
    for aa in "a b c d" ; do
        ALL+="$aa "
    done
else
    ALL=$*
fi

TESTME=1
. ../preinit.sh
. ../terminit.sh

# Pass individual test numbers per argument to see results

VERBOSE=3

for itemx in $ALL ; do
    echo Item: $itemx
    case "$itemx" in
        1)  getargy 'verbose' && echo "found VERBOSE=$FOUNDVAL"; VERBOSE="$FOUNDVAL" ;;
        2)  getargy 'bsleep' && echo "found bsleep=$FOUNDVAL"; echo would sleep "$FOUNDVAL" ;;
        3)  getargx 'initbreak=device' && tmpshell "Found VAR2: $FOUNDVAR $ " ;;
        4)  getargx 'hello' && tmpshell "Found VAR: $FOUNDVAR $ " ;;
        5)  getargx 'initbreak=post-gui' && tmpshell "Found VAR: $FOUNDVAR $ " ;;
        6)  tmpshell ;;
        7)  loaddevs ;;
        8)  loadmods ;;
        9)  startvts ;;

        a) downClean ;;
        b) shutdownx ;;
        c) getargx 'initbreak=all' && export BREAKALL=1
            echo "Found the $BREAKALL"
            getargx 'any and all' && echo "Found the 'ALL' VAR: $FOUNDVAR $ "
            ;;

        ?) echo "Please specify test case" ;;
    esac
done
# EOF
