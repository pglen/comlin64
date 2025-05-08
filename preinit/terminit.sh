#!/bin/bash
# shellcheck disable=SC2004,SC2009,SC2068,SC2002,SC1091

# Shutdown / Termination routines

shutDownx()  {

    # Shutdown command
    # These linux_* utils are needed, as the real shutdown program
    #   ... will refuse to run from chroot. (we are in CDROM chroot)

    local sfile sreflag AA

    if [ $(($VERBOSE)) -gt 1 ] ; then
        echo "shutDownx() " $@
    fi
    if [ $(($TESTME)) -gt 0 ] ; then
        sfile=shutdowncmd
    else
        sfile=$SDCOM
    fi
    read -r sreflag < "$sfile"
    if [ $(($VERBOSE)) -gt 1 ] ; then
        echo "Command in: $sfile -- reflag: $sreflag"
    fi
    # Do not need it any more ... but leave for debug
    #rm -f $SDCOM

    for AA in $sreflag ; do
        #echo aa: $AA
        if [ "$AA" = "-r" ] ; then
            if [ $(($TESTME)) -gt 0 ] ; then
                echo would reboot
            else
                if [ $(($VERBOSE)) -gt 0 ] ; then
                    echo calling linux_reboot
                fi
                echo -n "Rebooting ... "
                linux_reboot -f
            fi
        elif [ "$AA" = '-P' ]  ||  [ "$AA" = '-h' ] ; then
            if [ $(($TESTME)) -gt 0 ] ; then
                echo would poweroff
            else
                if [ $(($VERBOSE)) -gt 0 ] ; then
                    echo calling linux_poweroff
                fi
                echo -n "Shutting down ... "
                linux_poweroff -f
            fi
        else
            echo "Invalid shutdown cmd: $sreflag"
        fi
    done
}

umountAll() {

    if [ $(($VERBOSE)) -gt 1 ] ; then
       echo "umountAll() $0 " $@
    fi
    local cc PARTS
    IFS=$'\n'
    PARTS=$(lsblk -pl | awk '{printf("%s %s\n", $7, $6) }' | grep part | \
            awk '{printf("%s\n", $1) }' | grep -v part)
    #echo $PARTS

    # Flush and unmount all block partitions
    for cc in $PARTS ; do
        #echo cc $cc
        if [ "$cc" = "/" ] ; then
            #echo root match
            continue
        fi
        if [[ "$cc" =~ "/efi" ]] ; then
            #echo efi match
            continue
        fi

        if [ $(($TESTME)) -gt 0 ] ; then
            echo "Exec umount: $cc"
        else
            umount "$cc"
        fi
    done
    unset IFS
}

_termAll() {

    # Terminate all pocesses except $GOV without suiside / petriside
    # termAll(SIG, GOV)
    # SIG = signal; GOV = governor process;
    #    only higher numbers then governor are killed

    if [ $(($VERBOSE)) -gt 1 ] ; then
       echo "termAll() $0 " $@
    fi
    local AA PROCX
    PROCX=$(ps xa | awk '{print $1 }' | grep -v " *PID.*" | sort -n -r)

    if [ $(($VERBOSE)) -gt 2 ] ; then
       echo "procx:" "$PROCX"
    fi

    for AA in $PROCX ; do

        #echo -n loop: $AA

        if [ "1" -eq "$AA" ] ; then
            #echo 1
            continue;        # do not terminate preinit
        fi
        if [ "$2" -eq "$AA" ] ; then
            #echo gov $2
            continue;        # do not terminate preinit
        fi
        if [ "$$" -eq "$AA" ] ; then
            #echo curr $$
            continue;        # do not terminate this script
        fi

        if [ $((VERBOSE)) -gt 3 ] ; then
           echo "Killing ($1) $AA  "
        fi
        if [ $((TESTME)) -gt 0 ] ; then
            echo "Exec would kill on: $1 $AA"
        else
            # Send signal in the background
            kill "$1" "$AA"  >/dev/null 2>&1 &
        fi
    done
}

downClean() {

    # Clean for shutdown

    if [ $(($VERBOSE)) -gt 1 ] ; then
        echo "downclean() " $@
    fi

    local GOV

    #GOV=$(ps xa | grep  "postinit" | head -1 | awk '{print $1 }')
    GOV=$(ps xa | grep  "preinit" | head -1 | awk '{print $1 }')
    if [ $(($GOV)) -eq 0 ] ; then
        echo "Cannot get GOV process ID $GOV"
        # Picking a likely candidate
        GOV=$(ps xa | grep  "dbus" | head -1 | awk '{print $1 }')
    fi

    sync
    _termAll 15 "$GOV"
    sync
    sleep 1
    # Amp it up
    _termAll 9  "$GOV"
}

# EOF
