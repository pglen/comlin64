#!/bin/bash

# Our lib (note: in different dir on test)
#. ../shlib/preinitlib.sh

SUL=startuplog
mkdir -p $SUL

SULERR=log_err; SULOUT=log_out

echo "" > $SUL/$SULOUT; echo "" > $SUL/$SULERR

#lspci -v | grep "Kernel modules" | awk -F ":" '{ print($2); }' | \
#       grep -v modules | tr "," "\n"  | grep -v vbox | \
#       xargs -i echo mod: {}  >>$SUL/$SULOUT 2>>$SUL/$SULERR; sleep 0.05

#CMDLINE="initbreak=start 1234"
#getargx 'initbreak=start' && tmpshell "At the start of (pre)init $ "
##getargx 'initbreak=start' && echo command recognized

#../shlib/forever.sh -w 3 -n 10 echo -n ' hello world '

loadmods() {

    # Load modules intended for this system

    local IFS UNSP
    IFS=$'\n'
    FF=$(cat testfile)
    for AA in $FF ; do
        UNSP=${AA# }
        #echo UNSPsp "'"$UNSP"'"
        #echo "${UNSP:0:1}"
        if [ "${UNSP:0:1}" != "#" ] ; then
            echo $UNSP
        fi
    done
}

#loadmods

getargx() {

    # Get arg from command line. Return 1 for arg.

    local oo
    FNAME="testcline"
    if [ "$CMDLINE" = "" ]; then
        if [ -f $FFF ] ; then
            read CMDLINE < $FNAME
        fi
    fi
    #echo cmdline = $CMDLINE
    for oo in $CMDLINE; do
        #echo oo = $oo
	    [ "$oo" = "$1" ] && return 0;
    done
    return 1
}

#getargx "hello=str"; echo ret = $?
#getargx "hello=str2"; echo ret = $?

cmd2env()  {

    local oo cmd val
    FNAME="testcline"
    if [ "$CMDLINE" = "" ]; then
        if [ -f $FFF ] ; then
            read CMDLINE < $FNAME
        fi
    fi

    echo cmdline = "'"$CMDLINE"'"
    for oo in $CMDLINE; do
        #echo oo = $oo
        cmd=${oo%=*} ;  val=${oo#*=}
        if [ "$cmd" = "$val" ] ; then
            val=1
        fi
        echo "CMD STR:" $cmd=$val
        #read "$cmd" <<< $val
        $!cmd=$!val
        echo "var:" $cmd
	    #CMD_$oo=
    done

    #declare

}

cmd2env

# EOF
