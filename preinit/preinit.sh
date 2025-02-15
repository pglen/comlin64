#!/bin/bash
# shellcheck disable=SC2004,SC2009,SC2068,SC2002
# shellcheck disable=SC1091

export LIBVERS="1.0.0"

# Set the TESTME variable to non zero if you are in a
# simulation / test environment. Warning: it will not work in real env.
#TESTME=1

# COMLIN Linux boot lib

_readcmdline(){

    if [ $(($VERBOSE)) -gt 4 ] ; then
        echo "_readcmdline() $0 " $@
    fi
    # Only read it once
    if [ "$CMDLINE" != "" ] ; then
         #echo already got it $CMDLINE
         return
    fi
    # Read command line into variable
    local fname
    if [ $(($TESTME)) -gt 0 ] ; then
        fname="testcline"
    else
        fname="/var/cmdline"
    fi
    if [ -f $fname ] ; then
        read -r CMDLINE < "$fname"
    fi

    if [ $(($VERBOSE)) -gt 2 ] ; then
        echo "cmdline=$CMDLINE"
    fi
}

tmpshell() {

    # Temporary SHELL; Set prompt from $1

    if [ $(($VERBOSE)) -gt 3 ] ; then
        echo "tmpshell() $0 " $@
    fi
    _PROMPT="\"tmp shell $ \""
    if [ "$1" != "" ] ; then
        _PROMPT=\"$1\"
    fi
    if [ $(($TESTME)) -eq 0 ] ; then
        setsid -c -w /bin/bash --rcfile <(echo "PS1=$_PROMPT") -i
    else
        #(echo  PS1=$_PROMPT)
        #/bin/bash --rcfile <(echo "PS1=$_PROMPT") -i
        echo "Would start shell with prompt: $_PROMPT"
    fi
}

getargx() {

    # Get arg from command line. Return 1 for arg.

    if [ $(($VERBOSE)) -gt 5 ] ; then
        echo "getargx() $0 " $@
    fi
    # Obey script wide vars
    if [ $(($BREAKALL)) -gt 0 ] ; then
        export FOUNDVAR=$1
        return 0
    fi
    _readcmdline  $@
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

    if [ $(($VERBOSE)) -gt 5 ] ; then
        echo "getargy() " $@
    fi
    FOUNDCMD=""; FOUNDVAL=""
    _readcmdline $@
    local ooy rety=1
    for ooy in $CMDLINE; do
       if [ "${ooy%=*}" = "${1%=}" ]; then
            #echo "Found pair:" "${o#*=} ";
            export FOUNDCMD=${ooy%=*}; FOUNDVAL=${ooy#*=}
            rety=0; break
       fi
    done
    return $rety
}

loadmods() {

    # Load modules intended for this system

    #if [ $(($VERBOSE)) -gt 1 ] ; then
        echo "loadmods() " $@
    #fi

    local modx filex unsp
    IFS=$'\n'
    filex=$(cat /etc/modules)
    for modx in $filex ; do
        unsp=${modx# }
        if [ "${unsp:0:1}" != "#" ] ; then
            if [ $(($VERBOSE)) -gt 1 ] ; then
                echo "Loading module: $unsp"
            fi
            if [ $(($TESTME)) -gt 0 ] ; then
                echo "Would Load: $unsp"
            else
                modprobe "$unsp"
            fi
        fi
    unset IFS
    done
}

loaddevs() {

    # Install devices from PCI bus; ignore vbox additions for now

    if [ $(($VERBOSE)) -gt 0 ] ; then
        echo "loaddevs() " $@
    fi

    DEVS=$(lspci -v | grep "Kernel modules" | awk -F ":" '{ print($2); }' | \
           grep -v modules | tr "," "\n"  | grep -v vbox)

    if [ $(($TESTME)) -gt 0 ] ; then
        for aa in $DEVS ; do
            echo "Would load: $aa"
        done
    else
        for aa in $DEVS ; do
            if [ $(($VERBOSE)) -gt 0 ] ; then
                echo "Loading: $aa"
            fi
            modprobe "$aa" >>"$SULOUT" 2>>"$SULERR"
        done
    fi
}

startvts() {

    # Start virtual terminals and a serial port

    if [ $(($VERBOSE)) -gt 1 ] ; then
        echo "startvts() " $@
    fi

    local TT TERMS="tty2 tty3 tty4 ttyS0"

    for TT in $TERMS ; do
        if [ $(($VERBOSE)) -gt 0 ] ; then
            echo "Starting term: $TT"
        fi
        if [ $(($TESTME)) -gt 0 ] ; then
            echo "would exec: /usr/bin/setsid -c -w /sbin/agetty $TT 38400 linux >/dev/null 2>&1 >/dev/null 2>&1"
         else
            # We ececute in a sub shell, so it becomes its own
            /lib/shlib/forever.sh "/usr/bin/setsid /sbin/agetty $TT 38400 linux >/dev/null 2>&1" >/dev/null 2>&1 &
            #/lib/shlib/forever.sh "/usr/bin/setsid /sbin/agetty $TT 38400 linux >/tmp/vt-$TT 2>&1" >/dev/null 2>&1 &
            #/lib/shlib/forever.sh "/usr/bin/setsid /sbin/agetty $TT 38400" &
        fi
    done
}

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

    # Here one can examine post - cleanup
    getargx 'initbreak=post-cleanup' && tmpshell "Post cleanup $ "
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

# Hack to test from dev system
if [ $(($TESTME)) -gt 0 ] ; then
    return
fi

# End of file
#!/bin/bash

LIBVERS="1.0.0"

# Set the TESTME variable to non zero if you are in a
# simulation / test environment.

# COMLIN Linux boot lib

#set +x

_readcmdline(){

    if [ $(($VERBOSE)) -gt 4 ] ; then
        echo "_readcmdline() $0 " $@
    fi
    # Only read it once
    if [ "$CMDLINE" != "" ] ; then
         #echo already got it $CMDLINE
         return
    fi
    # Read command line into variable
    local fname
    if [ $(($TESTME)) -gt 0 ] ; then
        fname="testcline"
    else
        fname="/var/cmdline"
    fi
    if [ -f $fname ] ; then
        read -r CMDLINE <$fname
    fi

    if [ $(($VERBOSE)) -gt 2 ] ; then
        echo "cmdline=$CMDLINE"
    fi
}

tmpshell() {

    # Temporary SHELL; Set prompt from $1

    if [ $(($VERBOSE)) -gt 3 ] ; then
        echo "tmpshell() $0 " $@
    fi
    _PROMPT="\"tmp shell $ \""
    if [ "$1" != "" ] ; then
        _PROMPT=\"$1\"
    fi
    if [ $(($TESTME)) -eq 0 ] ; then
        setsid -c -w /bin/bash --rcfile <(echo "PS1=$_PROMPT") -i
        #export PS1="$_PROMPT"       # This did not work
        #setsid -c -w /bin/bash -i
    else
        #(echo  PS1=$_PROMPT)
        echo "Would start shell with prompt: $_PROMPT"
    fi
}

getargx() {

    # Get arg from command line. Return 1 for arg.

    if [ $(($VERBOSE)) -gt 5 ] ; then
        echo "getargx() " $@
    fi
    # Obey script wide vars
    if [ $(($BREAKALL)) -gt 0 ] ; then
        export FOUNDVAR=$1
        return 0
    fi
    _readcmdline
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

    if [ $(($VERBOSE)) -gt 5 ] ; then
        echo "getargy() " $@
    fi
    export FOUNDCMD="";
    export FOUNDVAL=""
    _readcmdline
    local ooy rety=1
    for ooy in $CMDLINE; do
       if [ "${ooy%=*}" = "${1%=}" ]; then
            #echo "Found pair:" "${o#*=} ";
            export FOUNDCMD=${ooy%=*}; FOUNDVAL=${ooy#*=}
            rety=0; break
       fi
    done
    return $rety
}

makedevices() {

    # Create the device nodes dynamically ...
    #    ... (stderr warned of dir loop -- killed it)

    if [ $(($VERBOSE)) -gt 2 ] ; then
        echo "makedevices() " $@
    fi
    IFS=$'\n'
    local sfiles onef devx majorx minorx
    sfiles=$(find /sys/class/sound -follow -type f -maxdepth 2 -name dev  2>/dev/null)
    #echo "sfiles: $sfiles"

    for onef in $sfiles ; do
        #echo "onef: $onef"
        [ -f "$onef" ] && majorx=$(cat "$onef" | awk -F ":" '{print $1}')
        [ -f "$onef" ] && minorx=$(cat "$onef" | awk -F ":" '{print $2}')
        devx="/dev/snd/"$(basename "${onef%/dev}")
        if [ $(($TESTME)) -gt 0 ] ; then
            echo -e "Device: $devx \tMajor/Minor: \t $majorx : $minorx"
        else
            mknod -m 0660 "$devx" c "$majorx" "$minorx" >>"$SULOUT" 2>>"$SULERR"
            chown root:audio "$devx"  >>"$SULOUT" 2>>"$SULERR"
        fi
    done
    unset IFS
}

# Pulled in for avoiding external file ...
#/lib/shlib/loadmods.sh

loadmods() {

    # Load modules intended for this system

    if [ $(($VERBOSE)) -gt 1 ] ; then
        echo "loadmods() $* "
    fi

    local modx filex unsp
    IFS=$'\n'
    filex=$(cat /etc/modules)
    for modx in $filex ; do
        unsp=${modx# }
        if [ "${unsp:0:1}" != "#" ] ; then
            if [ $(($VERBOSE)) -gt 1 ] ; then
                echo "Loading module: $unsp"
            fi
            if [ $(($TESTME)) -gt 0 ] ; then
                echo "Would Load: $unsp"
            else
                modprobe "$unsp"
            fi
        fi
    unset IFS
    done
}

mountHD() {

    if [ "$VERBOSE" != "" ] ; then
        echo "mountHD() $*"
    fi

    export MOUNT_DISK=""
    local ii DEVS
    DEVS=$(lsblk --raw | grep -v "NAME" | awk '{ print $1; }')
    #mkdir -p "$HDROOT"  >/dev/null 2>&1
    #echo "MountCD() $DEVS"
    for ii in $DEVS; do
        #echo "Test Drive" $ii
        sleep 0.01       # Needs to breathe
        DEVX="/dev/$ii"
        mount "$DEVX" "$HDROOT"  >/dev/null 2>&1
        if test -f "$HDROOT/.comlin_data" ; then
            #echo "Found COMLIN DATA at /dev/$ii"
            MOUNT_DISK=$DEVX
            return 0
        else
            umount "$DEVX" >/dev/null 2>&1
        fi
        done
    return 1
}

loaddevs() {

    # Install devices from PCI bus; ignore vbox additions for now

    if [ $(($VERBOSE)) -gt 0 ] ; then
        echo "loaddevs() " $@
    fi

    DEVS=$(lspci -v | grep "Kernel modules" | awk -F ":" '{ print($2); }' | \
           grep -v modules | tr "," "\n"  | grep -v vbox)

    if [ $(($TESTME)) -gt 0 ] ; then
        for aa in $DEVS ; do
            echo "Would load: $aa"
        done
    else
        for aa in $DEVS ; do
            modprobe "$aa" >>"$SULOUT" 2>>"$SULERR"
        done
    fi
}

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

    # Here one can examine post - cleanup
    getargx 'initbreak=post-cleanup' && tmpshell "Post cleanup $ "

    local aaa
    sfound=0
    for aaa in $sreflag ; do
        #echo aa: aaa
        if [ "$aaa" = "-r" ] ; then
            sfound=1
            if [ $(($TESTME)) -gt 0 ] ; then
                echo would reboot
            else
                if [ $(($VERBOSE)) -gt 0 ] ; then
                    echo calling linux_reboot
                fi
                linux_reboot -f
            fi
        elif [ "$aaa" = '-P' ]  ||  [ "$aaa" = '-h' ] ; then
            sfound=1
            if [ $(($TESTME)) -gt 0 ] ; then
                echo would poweroff
            else
                if [ $(($VERBOSE)) -gt 0 ] ; then
                    echo calling linux_poweroff
                fi
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

    local aa
    for aa in $procx ; do
        #echo -n loop: $aa
        if [ $$ -eq "$aa" ] ; then
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
        echo "downclean()" $@
    fi

    GOV=$(ps xa | grep  "preinit" | head -1 | awk '{print $1 }')
    if [ $(($GOV)) -eq 0 ] ; then
        echo "Cannot get GOV process ID $GOV"
        # Picking a likely candidate
        GOV=$(ps xa | grep  "dbus" | head -1 | awk '{print $1 }')
    fi
    termAll 15 $PPID "$GOV"
    sync
    # Amp it up
    termAll 9 $PPID "$GOV"
    #umountAll
}

# Hack to test from dev system
if [ $(($TESTME)) -gt 0 ] ; then
    return
fi

# End of file
