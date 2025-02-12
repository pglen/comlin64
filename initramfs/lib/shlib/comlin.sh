# ------------------------------------------------------------------------
# Custom Comlin library. Modifications by Peter Glen.
# I attempted to preserve as much of the original as it was practical.
#
# Thu 16.Jan.2025   Added some function descriptions.

# ------------------------------------------------------------------------
# Returns OK if $1 contains $2

strstr() {
  [ "${1#*$2*}" != "$1" ]
}

# ------------------------------------------------------------------------
# Get arg from command line. Return 1 for arg found.

getarg() {

    if [ ! -z $VERBOSE ] ; then
        echo "getarg() $@"
    fi

    set +x
    local o line
    if [ -z "$CMDLINE" ]; then
        if [ -e /var/cmdline ]; then
            while read line; do
                CMDLINE_ETC="$CMDLINE_ETC $line";
            done </var/cmdline;
        fi
       if [ -e /proc/cmdline ]; then
            read CMDLINE </proc/cmdline;
        fi
       CMDLINE="$CMDLINE $CMDLINE_ETC"
    fi
    #echo "cmdline $CMDLINE"
    for o in $CMDLINE; do
       [ "$o" = "$1" ] && { [ "$RDDEBUG" = "yes" ] && set -x; return 0; }
       [ "${o%%=*}" = "${1%=}" ] && { echo ${o#*=}; [ "$RDDEBUG" = "yes" ] && set -x; return 0; }
    done
    [ "$RDDEBUG" = "yes" ] && set -x
    return 1
}

# ------------------------------------------------------------------------

getargs() {

    if [ ! -z $VERBOSE ] ; then
        echo "getargs() $@"
    fi

    set +x
    local oo line
    FOUNDCMD=""; FOUNDVAL=""
    if [ -z "$CMDLINE" ]; then
       if [ -e /var/cmdline ]; then
            while read line; do
                CMDLINE_ETC="$CMDLINE_ETC $line";
            done </var/cmdline;
        fi
       read CMDLINE </proc/cmdline;
       CMDLINE="$CMDLINE $CMDLINE_ETC"
    fi
    #echo "cmdline = '" $CMDLINE "'"
    for oo in $CMDLINE; do
       if [ "${oo%=*}" = "${1%=}" ]; then
            #echo "Found:" "${o#*=} ";
            FOUNDCMD=${oo%=*}
            FOUNDVAL=${oo#*=}
            break
       fi
    done
}

# ------------------------------------------------------------------------

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

#setdebug

# ------------------------------------------------------------------------

source_all() {
    local f
    [ "$1" ] && [  -d "/$1" ] || return
    for f in "/$1"/*.sh; do [ -e "$f" ] && . "$f"; done
}

# ------------------------------------------------------------------------

source_conf() {
    local f
    [ "$1" ] && [  -d "/$1" ] || return
    for f in "/$1"/*.conf; do [ -e "$f" ] && . "$f"; done
}

# ------------------------------------------------------------------------

check_finished() {
    local f
    for f in /initqueue-finished/*.sh; do { [ -e "$f" ] && ( . "$f" ) ; } || return 1 ; done
    return 0
}

# ------------------------------------------------------------------------

check_quiet() {
    if [ -z "$COMLIN_QUIET" ]; then
    Comlin_QUIET="yes"
    getarg rdinfo && Comlin_QUIET="no"
    getarg quiet || Comlin_QUIET="yes"
    fi
}

# ------------------------------------------------------------------------

warn() {
    check_quiet
    echo "<4>Comlin Warning: $@" > /dev/kmsg
    [ "$Comlin_QUIET" != "yes" ] && \
        echo "Comlin Warning: $@" >&2
}

# ------------------------------------------------------------------------

info() {
    check_quiet
    echo "<6>Comlin: $@" > /dev/kmsg
    [ "$Comlin_QUIET" != "yes" ] && \
    echo "Comlin: $@"
}

# ------------------------------------------------------------------------

vinfo() {
    while read line; do
        info $line;
    done
}

# ------------------------------------------------------------------------

check_occurances() {
    # Count the number of times the character $ch occurs in $str
    # Return 0 if the count matches the expected number, 1 otherwise
    local str="$1"
    local ch="$2"
    local expected="$3"
    local count=0

    while [ "${str#*$ch}" != "${str}" ]; do
    str="${str#*$ch}"
    count=$(( $count + 1 ))
    done

    [ $count -eq $expected ]
}

# ------------------------------------------------------------------------

incol2() {
    local dummy check;
    local file="$1";
    local str="$2";

    [ -z "$file" ] && return;
    [ -z "$str"  ] && return;

    while read dummy check restofline; do
    [ "$check" = "$str" ] && return 0
    done < $file
    return 1
}

# ------------------------------------------------------------------------

udevsettle() {
    [ -z "$UDEVVERSION" ] && UDEVVERSION=$(udevadm --version)

    if [ $UDEVVERSION -ge 143 ]; then
        udevadm settle --exit-if-exists=/initqueue/work $settle_exit_if_exists >/dev/null 2>&1
    else
        udevadm settle --timeout=30 >/dev/null 2>&1
    fi
}

# ------------------------------------------------------------------------

wait_for_if_up() {
    local cnt=0
    while [ $cnt -lt 100 ]; do
       li=$(ip link show $1)
        [ -z "${li##*state UP*}" ] && return 0
        sleep 0.1
        cnt=$(($cnt+1))
    done
}

# root=nfs:[<server-ip>:]<root-dir>[:<nfs-options>]
# root=nfs4:[<server-ip>:]<root-dir>[:<nfs-options>]
# ------------------------------------------------------------------------

nfsroot_to_var() {
    # strip nfs[4]:
    local arg="$@:"
    nfs="${arg%%:*}"
    arg="${arg##$nfs:}"

    # check if we have a server
    if strstr "$arg" ':/*' ; then
    server="${arg%%:/*}"
    arg="/${arg##*:/}"
    fi

    path="${arg%%:*}"

    # rest are options
    options="${arg##$path}"
    # strip leading ":"
    options="${options##:}"
    # strip  ":"
    options="${options%%:}"

    # Does it really start with '/'?
    [ -n "${path%%/*}" ] && path="error";

    #Fix kernel legacy style separating path and options with ','
    if [ "$path" != "${path#*,}" ] ; then
    options=${path#*,}
    path=${path%%,*}
    fi
}

# ------------------------------------------------------------------------

ip_to_var() {
    local v=${1}:
    local i
    set --
    while [ -n "$v" ]; do
    if [ "${v#\[*:*:*\]:}" != "$v" ]; then
        # handle IPv6 address
        i="${v%%\]:*}"
        i="${i##\[}"
        set -- "$@" "$i"
        v=${v#\[$i\]:}
    else
        set -- "$@" "${v%%:*}"
        v=${v#*:}
    fi
    done

    unset ip srv gw mask hostname dev autoconf
    case $# in
    0)    autoconf="error" ;;
    1)    autoconf=$1 ;;
    2)    dev=$1; autoconf=$2 ;;
    *)    ip=$1; srv=$2; gw=$3; mask=$4; hostname=$5; dev=$6; autoconf=$7 ;;
    esac
}

# ------------------------------------------------------------------------

killproc() {

    if [ ! -z $VERBOSE ] ; then
        echo "killproc() $@"
    fi

    local exe="$(command -v $1)"
    local sig=$2
    local i
    [ -x "$exe" ] || return 1
    for i in /proc/[0-9]*; do
        [ "$i" = "/proc/1" ] && continue
        if [ -e "$i"/exe ] && [  "$i/exe" -ef "$exe" ] ; then
            kill $sig ${i##*/}
        fi
    done
}

# ------------------------------------------------------------------------

parse_iscsi_root()
{
    local v
    v=${1#iscsi:}

# extract authentication info
    case "$v" in
    *@*:*:*:*:*)
        authinfo=${v%%@*}
        v=${v#*@}
    # allow empty authinfo to allow having an @ in iscsi_target_name like this:
    # netroot=iscsi:@192.168.1.100::3260::iqn.2009-01.com.example:testdi@sk
        if [ -n "$authinfo" ]; then
            OLDIFS="$IFS"
            IFS=:
            set $authinfo
            IFS="$OLDIFS"
            if [ $# -gt 4 ]; then
                warn "Wrong authentication info in iscsi: parameter!"
                return 1
            fi
            iscsi_username=$1
            iscsi_password=$2
            if [ $# -gt 2 ]; then
                iscsi_in_username=$3
                iscsi_in_password=$4
            fi
        fi
        ;;
    esac

    # extract target ip
    case "$v" in
    [[]*[]]:*)
        iscsi_target_ip=${v#[[]}
        iscsi_target_ip=${iscsi_target_ip%%[]]*}
        v=${v#[[]$iscsi_target_ip[]]:}
        ;;
    *)
        iscsi_target_ip=${v%%[:]*}
        v=${v#$iscsi_target_ip:}
        ;;
    esac

    # extract target name
    case "$v" in
    *:iqn.*)
        iscsi_target_name=iqn.${v##*:iqn.}
        v=${v%:iqn.*}:
        ;;
    *:eui.*)
        iscsi_target_name=iqn.${v##*:eui.}
        v=${v%:iqn.*}:
        ;;
    *:naa.*)
        iscsi_target_name=iqn.${v##*:naa.}
        v=${v%:iqn.*}:
        ;;
    *)
        warn "Invalid iscii target name, should begin with 'iqn.' or 'eui.' or 'naa.'"
        return 1
        ;;
    esac

    # parse the rest
    OLDIFS="$IFS"
    IFS=:
    set $v
    IFS="$OLDIFS"

    iscsi_protocol=$1; shift # ignored
    iscsi_target_port=$1; shift
    if [ $# -eq 3 ]; then
        iscsi_iface_name=$1; shift
    fi
    if [ $# -eq 2 ]; then
        iscsi_netdev_name=$1; shift
    fi
    iscsi_lun=$1; shift
    if [ $# -ne 0 ]; then
        warn "Invalid parameter in iscsi: parameter!"
    return 1
    fi
}

# Functions for custom Comlin

# ------------------------------------------------------------------------
# Iterate /dev/sd[a-f][1-4] and /dev/sr[0-1],
# if we can mount it, test for the 'comboot' file.
# Revisions:
#             apr 4 2015:           Moved to Comlin
#             apr 6 2015:           Added locals
#                                   Removed ret code test from mount
#           Tue 24.Dec.2024         Reworked 64 bit
#           Tue 24.Dec.2024         Scanning lsblk

#DRIVES="/dev/sda /dev/sdb /dev/sdc /dev/sr0 /dev/sr1 \
#        /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh"

mountCD() {

    if [ ! -z $VERBOSE ] ; then
        echo "getarg() $@"
    fi

    local ii DEVS
    DEVS=$(lsblk --raw | grep -v "NAME" | awk '{ print $1; }')
    mkdir -p /mnt/guest  >/dev/null 2>&1
    #echo "MountCD() $DEVS"
    for ii in $DEVS; do
        #echo "Test Drive" $ii
        sleep 0.01       # Needs to breathe
        DEVX="/dev/$ii"
        mount $DEVX $CDROOT  >/dev/null 2>&1
        if test -f $CDROOT/etc/COMLINUX_VERSION; then
            #echo "Found COMLIN system at "/dev/$ii"
            MOUNT_DEVICE=$DEVX
            return 0
        else
            umount $DEVX >/dev/null 2>&1
        fi
        done
    return 1
}

# ------------------------------------------------------------------------

wait_for_loginit()
{
    if getarg rdinitdebug; then
    set +x
    exec 0<>/dev/console 1<>/dev/console 2<>/dev/console
    # wait for loginit
    i=0
    while [ $i -lt 10 ]; do
        j=$(jobs)
        [ -z "$j" ] && break
        [ -z "${j##*Running*}" ] || break
        sleep 0.1
        i=$(($i+1))
    done
    [ $i -eq 10 ] && kill %1  >/dev/null 2>&1

        while pidof -x /sbin/loginit   >/dev/null 2>&1; do
            for pid in $(pidof -x /sbin/loginit); do
                kill $HARD $pid   >/dev/null 2>&1
            done
            HARD="-9"
        done
    set -x
    fi
}

# ------------------------------------------------------------------------
# use: temporary_shell [-n]

temporary_shell()
{
    if [ ! -z $VERBOSE ] ; then
        echo "temporary_shell() $@"
    fi
    set +e
    local _shell_name
    _shell_name="Comlin # "
    if [ "$1" = "-n" ]; then
        _shell_name=$2
        shift 2
    fi
    export PS1="$_shell_name:\${PWD}# "
    echo
    setsid -c -w /bin/bash
}

# EOF