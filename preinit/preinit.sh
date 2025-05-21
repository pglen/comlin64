#!/bin/bash
# shellcheck disable=SC2002,SC2048,SC2068

# COMLIN Linux boot lib: Thu 20.Mar.2025

export LIBVERS="1.0.0"

COMLIN_DATAFILE=.comlin_data

# Log files for startup
export SUL="/var/log/startuplogs"
export SULERR=$SUL/log_err; SULOUT=$SUL/log_out

# This way udev is functional in chroot
export SYSTEMD_IGNORE_CHROOT=1

# Do all that one needs in memory
export TMP=/tmp
export TEMP=$TMP
export RUN=/run

# Set the TESTME variable to non zero if you are in a
# simulation / test environment. Warning: it will not work in real env.
#TESTME=1

loginfo() {

    # Show info. use: loginfo Level [opts] [strs]
    # Option -t must be the first

    #echo args1: "$@"
    local ARG TT
    ARG=$1; TT=0
    if [ $((VERBOSE)) -lt $((ARG)) ] ; then
        return
    fi
    shift
    while : ; do
        was=0
        case $1 in
            "-t")
            shift; was=1; TT=1
            ;;
            "")
        esac
        if [ $was -eq 0 ] ;then
            break
        fi
    done

    if [ $TT -eq 0 ] ; then
        echo -n "$(uptime 1) "
    fi

    echo "$@"
}

logok(){
    local LEVEL
    LEVEL=$1
    if [ $((VERBOSE)) -ge $((LEVEL)) ] ; then
        echo -e " \033[32;1mOK\033[0m"
    fi
}

prompt() {
    local keyx respx
    respx=0
    while : ; do
        echo -n "$*"
        read -r keyx
        if [ "$keyx" == "yes" ] || [ "$keyx" == "YES" ] ; then
            respx=1
            break
        fi
        if [ "$keyx" == "no" ]  || [ "$keyx" == "NO" ] ; then
            break
        fi
    done
    return $respx
}

tmpshell() {

    # Temporary SHELL; Set prompt from $1

    if [ $((VERBOSE)) -gt 3 ] ; then
        echo "tmpshell() $0 $* "
    fi
    _PROMPT="\"tmp shell $ \""
    if [ "$1" != "" ] ; then
        _PROMPT=\"$1\"
    fi
    if [ $((TESTME)) -eq 0 ] ; then
        setsid -c -w /bin/bash --rcfile <(echo "PS1=$_PROMPT") -i
        #export PS1="$_PROMPT"       # This did not work
        #setsid -c -w /bin/bash -i
    else
        #(echo  PS1=$_PROMPT)
        echo "Would start shell with prompt: $_PROMPT"
    fi
}

_readcmdline(){

    # Only read it once
    if [ "$CMDLINE" != "" ] ; then
         #echo already got it $CMDLINE
         return
    fi
    if [ $((VERBOSE)) -gt 4 ] ; then
        echo "_readcmdline() $0  $* "
    fi
    # Read command line into variable
    local fname
    if [ $((TESTME)) -gt 0 ] ; then
        fname="testcline"
    else
        fname="/var/cmdline"
    fi
    if [ -f $fname ] ; then
        read -r CMDLINE <$fname
    fi

    if [ $((VERBOSE)) -gt 2 ] ; then
        echo "cmdline=$CMDLINE"
    fi
}

getargx() {

    # Get arg from command line. Return 1 for arg.

    if [ $((VERBOSE)) -gt 5 ] ; then
        echo "getargx() $0 $*"
    fi
    # Obey script wide vars
    if [ $((BREAKALL)) -gt 0 ] ; then
        export FOUNDVAR=$1
        return 0
    fi
    _readcmdline  "$@"
    local oox retx=1
    for oox in $CMDLINE; do
       if [ "$oox" = "$1" ] ; then
            retx=0
            export FOUNDVAR=$oox
            break
       fi
    done
    return $retx
}

getargy() {

    if [ $((VERBOSE)) -gt 5 ] ; then
        echo "getargy()  $* "
    fi
    FOUNDCMD=""; FOUNDVAL=""
    _readcmdline "$@"
    local ooy rety=1
    for ooy in $CMDLINE; do
       if [ "${ooy%=*}" = "${1%=}" ]; then
            #echo "Found pair:" "${o#*=} ";
            export FOUNDCMD=${ooy%=*};
            export FOUNDVAL=${ooy#*=}
            rety=0; break
       fi
    done
    return $rety
}

# Load module in not loaded

modprobeif() {

    local ISMOD
    ISMOD=$(lsmod | grep "$1")
    #echo ISMOD: \"$ISMOD\"
    if [ "$ISMOD" == "" ] ; then
       loginfo 3 "Loading: $1"
       modprobe "$1" >>"$SULOUT" 2>>"$SULERR" #>/dev/null 2>&1
    fi
}

loadmods() {

    # Load modules intended for this system

    if [ $((VERBOSE)) -gt 1 ] ; then
        echo "loadmods()"
    fi
    local modx unsp
    while read -r modx ;
        do
            if [ $((VERBOSE)) -gt 8 ] ; then
                echo "line = [$modx]"
            fi
            unsp=${modx# }
            if [ "${unsp}" == "" ] ; then
                continue
            fi
            if [ "${unsp:0:1}" == "#" ] ; then
                if [ $((VERBOSE)) -gt 7 ] ; then
                    echo "Comment $unsp"
                fi
                continue
            fi
            if [ $((VERBOSE)) -gt 5 ] ; then
                echo -n "Loading module: \'$unsp\' "
            fi
            if [ $((TESTME)) -gt 0 ] ; then
                echo "Would Load:" "'""$unsp""'"
            else
                modprobeif "$unsp"
            fi
        done < /etc/modules
}

loadvirt() {

    if [ $((VERBOSE)) -gt 0 ] ; then
        echo "loadvirt()  "
    fi
    # Hypervisor present?
    HYPER=$(grep hypervisor /proc/cpuinfo)
    if [ "$HYPER" == "" ] ; then
        if [ $((VERBOSE)) -gt 1 ] ; then
            echo " No hypervisor."
        fi
        return
    fi
    DEVS=$(lspci -v | grep "Kernel " | awk -F ":" '{ print($2); }' | \
           grep -v modules | tr "," "\n"  | grep vbox)
    if [ $((VERBOSE)) -gt 1 ] ; then
        echo "DEVS:" "$DEVS"
    fi
    for aa in $DEVS ; do
        if [ $((TESTME)) -gt 0 ] ; then
            echo "Would load: $aa"
        else
            if [ $((VERBOSE)) -gt 1 ] ; then
                echo -n "Device: $aa "
            fi
            modprobeif "$aa"  #>>"$SULOUT" 2>>"$SULERR"
        fi
    done
}

loaddevs() {

    # Install devices from PCI bus; ignore vbox additions for now

    if [ $((VERBOSE)) -gt 0 ] ; then
        echo "loaddevs()  "
    fi

    DEVS=$(lspci -v | grep "Kernel " | awk -F ":" '{ print($2); }' | \
           grep -v modules | tr "," "\n"  | grep -v vbox)

    for aa in $DEVS ; do
        if [ $((TESTME)) -gt 0 ] ; then
            echo "Would load: $aa"
        else
            if [ $((VERBOSE)) -gt 1 ] ; then
                echo -n "Device: $aa "
            fi
            modprobeif "$aa"  #>>"$SULOUT" 2>>"$SULERR"
        fi
        done
}

startvts() {

    # Start virtual terminals and a serial port

    if [ $((VERBOSE)) -gt 1 ] ; then
        echo "startvts()  $*"
    fi

    local TT TERMS="tty2 tty3 tty4 " # ttyS0"

    for TT in $TERMS ; do
        if [ $((VERBOSE)) -gt 0 ] ; then
            echo -n "Term: $TT "
        fi
        if [ $((TESTME)) -gt 0 ] ; then
            echo "would exec: /usr/bin/setsid -c -w /sbin/agetty $TT 38400 linux >/dev/null 2>&1 >/dev/null 2>&1"
         else
            # We ececute in a sub shell, so it becomes its own
            #/lib/shlib/forever.sh "/usr/bin/setsid  /sbin/agetty $TT 38400 linux >/dev/null 2>&1" >/dev/null 2>&1 &
            /lib/shlib/forever.sh "/usr/bin/setsid /sbin/agetty $TT 38400 linux >/tmp/vt-$TT 2>&1" >/tmp/vt 2>&1 &
            #/lib/shlib/forever.sh "/usr/bin/setsid /sbin/agetty $TT 38400" &
        fi
    done
}

# Hack to test from dev system
if [ $((TESTME)) -gt 0 ] ; then
    return
fi

# Set the TESTME variable to non zero if you are in a
# simulation / test environment.

#set +x


make_sound_devices() {

    # Create the sound device nodes dynamically ...
    #    ... (stderr warned of dir loop -- silenced it)

    if [ $((VERBOSE)) -gt 1 ] ; then
        echo "make_sound_devices() $*"
    fi
    IFS=$'\n'
    local sfiles onef devx majorx minorx
    sfiles=$(find /sys/class/sound -follow -type f -maxdepth 2 -name dev  2>/dev/null)
    if [ $((VERBOSE)) -gt 1 ] ; then
        echo "sfiles: $sfiles"
    fi

    for onef in $sfiles ; do
        if [ $((VERBOSE)) -gt 3 ] ; then
            echo "onef: $onef"
        fi
        [ -f "$onef" ] && majorx=$(cat "$onef" | awk -F ":" '{print $1}')
        [ -f "$onef" ] && minorx=$(cat "$onef" | awk -F ":" '{print $2}')
        devx="/dev/snd/"$(basename "${onef%/dev}")
        if [ $((TESTME)) -gt 0 ] ; then
            echo -e "Device: $devx \tMajor/Minor: \t $majorx : $minorx"
        else
            # TODO rm ?
            if [ $((VERBOSE)) -gt 1 ] ; then
                echo mknod "$devx" major: "$majorx" minor: "$minorx"
            fi
            mknod -m 0660 "$devx" c "$majorx" "$minorx" >>"$SULOUT" 2>>"$SULERR"
            chown root:audio "$devx"  >>"$SULOUT" 2>>"$SULERR"
        fi
    done
    unset IFS
}

findHD() {

    if [ $((VERBOSE)) -gt 1  ] ; then
        echo "findHD() $*"
    fi

    export MOUNT_DISK=""
    local ii DEVS
    DEVS=$(lsblk --raw | grep -v "NAME" | awk '{ print $1; }')
    #mkdir -p "$HDROOT"  >/dev/null 2>&1
    for ii in $DEVS; do
        if [ $((VERBOSE)) -gt 1 ] ; then
            echo -n "Testing Drive: $ii  "
        fi
        sleep 0.01       # Needs to breathe
        DEVX="/dev/$ii"
        mount  "$DEVX" "$HDROOT"  >/dev/null 2>&1
        if test -f "$HDROOT/$COMLIN_DATAFILE" ; then
            if [ $((VERBOSE)) -gt 2 ] ; then
                echo "Found COMLIN DATA at /dev/$ii"
            fi
            MOUNT_DISK=$DEVX
            umount "$DEVX" >/dev/null 2>&1
            return 0
        else
            umount "$DEVX" >/dev/null 2>&1
        fi
        done

    if [ $((VERBOSE)) -gt 1 ] ; then
        echo "No writable drive found"
    fi

    return 1
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
    TTT2=$(getmilli
    )
    TTT3=$((TTT2-TTT0))
    SECS=$((TTT3 / 1000))
    MSECS=$((TTT3 % 1000))
    printf "%d.%-3d " $SECS $MSECS
    }

uptime() {

    local TTT
    TTT=$(cat /proc/uptime | awk '{print $1}')

    #echo $TTT
    HH=$(echo "$TTT  / 3600 " | bc)
    MM=$(echo "($TTT / 60) % 60" | bc)
    SS=$(echo " ($TTT  % 60) " | bc)
    NN=$(echo "($TTT % 1) * 100" | bc)

    if [ "1" == "$1" ] ; then
        printf "%02.0f.%02.0f " "$SS" "$NN"
    elif [ "2" == "$1" ] ; then
        printf "%02.0f:%02.0f.%02.0f " "$MM" "$SS" "$NN"
    else
        printf "%02.0f:%02.0f:%02.0f.%02.0f " "$HH" "$MM" "$SS" "$NN"
    fi
}

ALLFILES="\
/usr/bin/chfn \
/usr/bin/chsh \
/bin/chvt \
/bin/fusermount3 \
/bin/mount \
/usr/bin/newgrp \
/bin/su \
/usr/bin/sudo \
/bin/umount \
/usr/bin/at \
/usr/bin/chfn \
/usr/bin/chsh \
/usr/bin/chvt \
/bin/fusermount \
/bin/fusermount3 \
/usr/bin/gpasswd \
/usr/bin/mount \
/usr/bin/newgrp \
/usr/bin/passwd \
/usr/bin/pkexec \
/usr/bin/su \
/usr/bin/sudo \
/usr/bin/umount \
/usr/lib/dbus-1.0/dbus-daemon-launch-helper \
/usr/libexec/polkit-agent-helper-1 \
/usr/sbin/pppd \
"
#echo $ALLFILES

setsuids() {

    for AA in $ALLFILES ; do
        #echo $ROOTFS$AA
        chmod u+s "$ROOTFS""$AA"
    done
}

bindall() {

    mkdir -p "$1"/proc
    mount --bind /proc "$1"/proc

    mkdir -p "$1"/sys
    mount --bind /sys "$1"/sys

    mkdir -p "$1"/dev
    mount --bind /dev "$1"/dev

    #mkdir -p "$1"/dev/pts
    #mount --bind /dev/pts "$1"/dev/pts

    mkdir -p "$1"/orig
    mount --bind /orig "$1"/orig

    mkdir -p "$1"/cdroot
    mount --bind /cdroot "$1"/cdroot

    # This one needs explicit creation (--bind did not work)
    udevadm settle -t 5
    mkdir -p "$1"/dev/pts
    mount -t devpts devpts "$1"/dev/pts
}
# Force trigger and load

devload() {

    loginfo 0 -n "$1"

    udevadm trigger -c add -t subsystems
    udevadm settle -t 5
    udevadm trigger -c add -t devices
    udevadm settle -t 5

    loadmods ;  udevadm settle -t 5
    loaddevs ;  udevadm settle -t 5
    loadvirt ;  udevadm settle -t 5

    loginfo 0 -t -e " \033[32;1mOK\033[0m"
}

# Change root and execute postinit

post_chroot() {
    chroot "$NEWROOT" setsid /sbin/postinit
    #echo "Back from postinit"
    getargx 'ibreak=post-down' && tmpshell "$FOUNDVAR $ "
}

# Execute items with pre / post display

exec_items() {

    local AAA
    getargx "ibreak=$1" && tmpshell "$FOUNDVAR $ "
    loginfo 0 -n "Starting $2 ... "
    shift; shift
    for AAA in "$@" ; do
        if [ $((VERBOSE)) -gt 0 ] ; then
            echo "Exec: $AAA"
        fi
        $AAA  >>$SULOUT 2>>$SULERR &
    done
    getargy 'isleep' && sleep "$FOUNDVAL"
    loginfo 0 -t -e " \033[32;1mOK\033[0m"
}

# Hack to test from dev system
if [ $((TESTME)) -gt 0 ] ; then
    return
fi

# End of file
