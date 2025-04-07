#!/bin/bash
# shellcheck disable=SC1090,SC2048,SC2086

# Custom Comlin INIT library.
#
# Thu 16.Jan.2025   Added some function descriptions.
# Mon 07.Apr.2025   Moved to local init dir, added loginfo2

# Echo if logifo level or greater

loginfo2() {
    local ARG
    ARG=$1
    if [ $((VERBOSE)) -ge $((ARG)) ] ; then
        shift
        echo -n "$(ptime) "
        echo $*
    fi
}

# Returns OK if $1 contains $2

strstr() {
  [ "${1#*"$2"*}" != "$1" ]
}

# Get arg from command line. Return 1 for arg found.

getarg() {

    loginfo2 6 "getarg() $*"

    set +x
    local o line
    if [ -z "$CMDLINE" ]; then
        if [ -e /var/cmdline ]; then
            while read -r line; do
                CMDLINE_ETC="$CMDLINE_ETC $line";
            done </var/cmdline;
        fi
       if [ -e /proc/cmdline ]; then
            read -r CMDLINE </proc/cmdline;
        fi
       CMDLINE="$CMDLINE $CMDLINE_ETC"
    fi
    #echo "cmdline $CMDLINE"
    for o in $CMDLINE; do
       [ "$o" = "$1" ] && { [ "$RDDEBUG" = "yes" ] && set -x; return 0; }
       [ "${o%%=*}" = "${1%=}" ] && { echo "${o#*=}"; [ "$RDDEBUG" = "yes" ] && set -x; return 0; }
    done
    [ "$RDDEBUG" = "yes" ] && set -x
    return 1
}

getargs() {

    loginfo2 5 "getargs() $*"

    set +x
    local oo line
    export FOUNDCMD=""
    export FOUNDVAL=""
    if [ -z "$CMDLINE" ]; then
       if [ -e /var/cmdline ]; then
            while read -r line; do
                CMDLINE_ETC="$CMDLINE_ETC $line";
            done </var/cmdline;
        fi
       read -r CMDLINE </proc/cmdline;
       CMDLINE="$CMDLINE $CMDLINE_ETC"
    fi
    loginfo2 2 "cmdline =  \'$CMDLINE"\'
    for oo in $CMDLINE; do
       if [ "${oo%=*}" = "${1%=}" ]; then
            #echo "Found:" "${o#*=} ";
            FOUNDCMD=${oo%=*}
            FOUNDVAL=${oo#*=}
            break
       fi
    done
}

setdebug() {
    if [ -z "$RDDEBUG" ]; then
        if [ -e /proc/cmdline ]; then
            RDDEBUG=no
            if getarg rdinitdebug || getarg rdnetdebug; then
                RDDEBUG=yes
            fi
        fi
    fi
    [ "$RDDEBUG" = "yes" ] && set -x
}

source_all() {
    local f
    [ "$1" ] && [  -d "/$1" ] || return
    for f in "/$1"/*.sh; do [ -e "$f" ] && . "$f"; done
}

source_conf() {
    local f
    [ "$1" ] && [  -d "/$1" ] || return
    for f in "/$1"/*.conf; do [ -e "$f" ] && . "$f"; done
}

check_finished() {
    local f
    for f in /initqueue-finished/*.sh; do { [ -e "$f" ] && ( . "$f" ) ; } || return 1 ; done
    return 0
}

check_occurances() {
    # Count the number of times the character $ch occurs in $str
    # Return 0 if the count matches the expected number, 1 otherwise
    local str="$1"
    local ch="$2"
    local expected="$3"
    local count=0

    while [ "${str#*"$ch"}" != "${str}" ]; do
    str="${str#*"$ch"}"
    count=$((count + 1))
    done

    [ $count -eq "$expected" ]
}

wait_for_if_up() {
    local cnt=0
    while [ $cnt -lt 100 ]; do
       li=$(ip link show "$1")
        [ -z "${li##*state UP*}" ] && return 0
        sleep 0.1
        cnt=$((cnt+1))
    done
}

killproc() {

    if [ $((VERBOSE)) -gt 1 ] ; then
        echo "killproc() $*"
    fi

    local exe sig i
    exe=$(command -v "$1")
    sig=$2
    [ -x "$exe" ] || return 1
    for i in /proc/[0-9]*; do
        [ "$i" = "/proc/1" ] && continue
        if [ -e "$i"/exe ] && [  "$i/exe" -ef "$exe" ] ; then
            kill "$sig" "${i##*/}"
        fi
    done
}

# Retry mount seral times in one go.

findCD() {

    local RETRYCNT=10 DELAYONE=0.5 cntx
    cntx=0
    while :; do
        if [ $cntx -gt $RETRYCNT ] ; then
           break
        fi
        mountCD "$1"
        if [ "$MOUNT_DEVICE" != "" ] ; then
           break
        fi
        cntx=$((cntx+1))
        sleep $DELAYONE
    done
}

# Iterate /dev/sd[a-f][1-4] and /dev/sr[0-1],
# if we can mount it, test for the 'comboot' file.
# Revisions:
#             apr 4 2015:           Moved to Comlin
#             apr 6 2015:           Added locals
#                                   Removed ret code test from mount
#           Tue 24.Dec.2024         Reworked 64 bit
#           Tue 24.Dec.2024         Scanning lsblk

mountCD() {

    if [ $((VERBOSE)) -gt 1 ] ; then
        echo "_mountcd() $*"
    fi

    partprobe
    export MOUNT_DEVICE=""

    local ii DEVS
    DEVS=$(lsblk --raw | grep -v "NAME" | awk '{ print $1; }')
    mkdir -p /mnt/guest  >/dev/null 2>&1
    #echo "MountCD() $DEVS"
    for ii in $DEVS; do
        loginfo2 1 "Test Drive: /dev/$ii"
        sleep 0.01       # Needs to breathe
        DEVX="/dev/$ii"
        mount -o silent "$DEVX" "$CDROOT"  >/dev/null 2>&1
        if [ -f "$CDROOT/etc/COMLINUX_VERSION" ] ; then
            loginfo2 0 "Found COMLIN SYSTEM at /dev/$ii"
            MOUNT_DEVICE=$DEVX
            return 0
        else
            umount "$DEVX" >/dev/null 2>&1
        fi
        done
    return 1
}

wait_for_loginit()
{
    if getarg rdinitdebug; then
    set +x
    exec 0<>/dev/console 1<>/dev/console 2<>/dev/console
    # wait for loginit
    i=0
    while [ "$ii" -lt 10 ]; do
        j=$(jobs)
        [ -z "$j" ] && break
        [ -z "${j##*Running*}" ] || break
        sleep 0.1
        ii=$((ii+1))
    done
    [ $ii -eq 10 ] && kill %1  >/dev/null 2>&1

        while pidof -x /sbin/loginit   >/dev/null 2>&1; do
            for pid in $(pidof -x /sbin/loginit); do
                kill "$HARD" "$pid"   >/dev/null 2>&1
            done
            HARD="-9"
        done
    set -x
    fi
}

# use: temporary_shell [-n]

temporary_shell()
{
    if [ $((VERBOSE)) -gt 1 ] ; then
        echo "temporary_shell() $*"
    fi
    set +e
    local _shell_name
    _shell_name="Comlin # "
    if [ "$1" = "-n" ]; then
        _shell_name=$2
        shift 2
    fi
    export PS1="$_shell_name:\${PWD}# "
    #trap "echo Stopping temporarily, type exit to continue; temporary_shell \"CTRL-C caught!\" " 2
    echo
    setsid -c -w /bin/bash
}

loadmods2() {

    # Load modules intended for this system

    loginfo2 1 "loadmods() $* "
    local MODX UNSP
    while read -r MODX ;
    do
        loginfo2 7 "line: \'$MODX\'"
        UNSP=${MODX# }
        if [ "${UNSP}" == "" ] ; then
            continue
        fi
        #echo UNSP: "'"$UNSP"'"
        if [ "${UNSP:0:1}" == "#" ] ; then
            #echo Comment $UNSP
            continue
        fi
        loginfo2 6 "Loading module: $UNSP"

        if [ $((TESTME)) -gt 0 ] ; then
            echo "Would Load:" "'""$UNSP""'"
        else
            modprobe "$UNSP" >/dev/null 2>&1
        fi
    done < etc/modules
}

# Get milli seconds from epoch
getmilli()
{
    echo $(($(date +%s%N)/1000000))
}

SFILE=/.starttime

tanchor()
{
    #export TTT0
    TTT0=$(getmilli)
    echo "$TTT0" > $SFILE
}

readanchor() {
    read -r TTT0 < $SFILE
}

ptime() {

    local TTT2 TTT3 SECS MSECS
    TTT2=$(getmilli)
    TTT3=$((TTT2-TTT0))
    SECS=$((TTT3 / 1000))
    MSECS=$((TTT3 % 1000))
    printf "%d.%-3d " $SECS $MSECS
    }

# EOF