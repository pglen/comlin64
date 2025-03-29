#!/bin/bash
# shellcheck disable=SC2004,SC2009,SC2068,SC2002,SC1091

# Shutdown / Termination routines

shutdownx()  {

    # Shutdown command
    # These linux_* utils are needed, as the real shutdown program
    #   ... will refuse to run from chroot. (we are in CDROM chroot)

    local sfile sreflag sfound

    if [ $(($VERBOSE)) -gt 1 ] ; then
        echo "shutdownx() " $@
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
    # Do not need it any more ??? ... leave for debug
    #rm -f $SDCOM

    # We have to work out the details of this
    #downClean

    local AA
    sfound=0
    for AA in $sreflag ; do
        #echo aa: $AA
        if [ "$AA" = "-r" ] ; then
            sfound=1
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
            sfound=1
            if [ $(($TESTME)) -gt 0 ] ; then
                echo would poweroff
            else
                if [ $(($VERBOSE)) -gt 0 ] ; then
                    echo calling linux_poweroff
                fi
                echo -n "Shutting down ... "
                linux_poweroff -f
            fi
        fi
    done

    if [ $sfound -eq 0 ] ; then
        echo "Invalid shutdown cmd: $sreflag"
    fi
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

termAll() {

    # Terminate all pocesses higher than $GOV without suiside / petriside
    # termAll(SIG, PAR, GOV)
    # SIG = signal; PAR = parent; GOV = governor process;
    #    only higher numbers then governor are killed

    if [ $(($VERBOSE)) -gt 1 ] ; then
       echo "termAll() $0 " $@
    fi

    procx=$(ps xa | awk '{print $1 }' | grep -v " *PID.*" | sort -n -r)

    if [ $(($VERBOSE)) -gt 2 ] ; then
       echo "$procx"
    fi

    for aa in $procx ; do

        #echo -n loop: $aa

        if [ "$$" -eq "$aa" ] ; then
            #echo curr $$
            continue;        # do not terminate this script
        fi
        if [ "$2" -eq "$aa" ] ; then
            #echo par $ME
            continue;        # do not terminate parent script
        fi
        # Kill everything higher PID than GOV
        if [ "$3" -lt "$aa" ] ; then

            if [ $(($VERBOSE)) -gt 5 ] ; then
               echo "Killing  ($1) $aa  "
            fi

            if [ $(($TESTME)) -gt 0 ] ; then
                echo "Exec would kill on: $1 $aa"
            else
                # Send signal in the background
                kill "$1" "$aa"  >/dev/null 2>&1 &
            fi
        fi
    done
}

downClean() {

    # Clean for shutdown

    if [ $(($VERBOSE)) -gt 1 ] ; then
        echo "downclean() " $@
    fi

    GOV=$(ps xa | grep  "preinit" | head -1 | awk '{print $1 }')
    if [ $(($GOV)) -eq 0 ] ; then
        echo "Cannot get GOV process ID $GOV"
        # Picking a likely candidate
        GOV=$(ps xa | grep  "dbus" | head -1 | awk '{print $1 }')
    fi

    termAll 15 "$PPID" "$GOV"
    sync

    # Amp it up
    termAll 9 "$PPID" "$GOV"
    #umountAll
}

