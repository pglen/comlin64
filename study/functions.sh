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

mountANY() {
    local ii iii DEVS
    DEVS=$(lsblk --raw | grep -v "NAME" | awk '{ print $1; }')
    mkdir -p /mnt/guest  >/dev/null 2>&1

    for ii in $DEVS; do
        #echo "Drive" $ii
        sleep 0.01       # Needs to breathe
        DEVX="/dev/$ii"
        mount $DEVX /mnt/guest  >/dev/null 2>&1
        if test -f /mnt/guest/etc/COMLINUX_VERSION; then
            #echo "Found COMLIN system at "/dev/$ii"
            umount $DEVX >/dev/null 2>&1
            DEVICE=$DEVX
            return 0
        else
            umount $DEVX >/dev/null 2>&1
        fi
        done
    return 1
}

# ------------------------------------------------------------------------

#dosh()
#{
#    export PS1="Tmp Shell\${PWD}# "
#    #[ -e /.profile ] || echo "exec 0<>/dev/console 1<>/dev/console 2<>/dev/console" > /.profile
#    #sh -i -l
#    setsid -c -w /bin/bash
#}
#
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

emergency_shell()
{
    set +e
    if [ "$1" = "-n" ]; then
        _rdshell_name=$2
        shift 2
    else
        _rdshell_name=Comlin
    fi
    #wait_for_loginit
    #echo ; echo
    #warn $@
    #source_all emergency
    #echo

    #[ -e /.die ] && sleep 3; exit 1

    warn "Exiting this shell will return to the Comlin script"

    if getarg rdshell || getarg rdbreak; then
        echo "Dropping to debug shell."
        echo
        export PS1="$_rdshell_name:\${PWD}# "
        #[ -e /.profile ] || echo "exec 0<>/dev/console 1<>/dev/console 2<>/dev/console" > /.profile
        #sh -i -l
        setsid -c -w /bin/bash
    else
        #warn "Boot has failed. To debug this issue add \"rdshell\" to the kernel command line."
        export PS1="$_rdshell_name:\${PWD}# "
        #[ -e /.profile ] || echo "exec 0<>/dev/console 1<>/dev/console 2<>/dev/console" > /.profile
        #sh -i -l
        echo
        setsid -c -w /bin/bash
        #exit 1
    fi
}

# EOF
