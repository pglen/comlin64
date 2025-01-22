#!/bin/bash

cmd2env()  {

    # Futile attempt to plu cmdline into env

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
        declare  -- "$cmd"="$val"
        echo "var:" "$cmd" varx=$val
	    #CMD_$oo=
    done
}

cmd2env

# EOF