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

#cmd2env()  {
#    # Futile attempt to plu cmdline into env
#    local oo cmd val
#    FNAME="testcline"
#    if [ "$CMDLINE" = "" ]; then
#        if [ -f $FFF ] ; then
#            read CMDLINE < $FNAME
#        fi
#    fi
#    echo cmdline = "'"$CMDLINE"'"
#    for oo in $CMDLINE; do
#        #echo oo = $oo
#        cmd=${oo%=*} ;  val=${oo#*=}
#        if [ "$cmd" = "$val" ] ; then
#            val=1
#        fi
#        echo "CMD STR:" $cmd=$val
#        #read "$cmd" <<< $val
#        $!cmd=$!val
#        echo "var:" $cmd
#	    #CMD_$oo=
#    done
#cmd2env

TESTME=1
. ../preinit

#VERBOSE=0

#getargx work   ;  echo "ret" $?
#getargx world  ;  echo "ret" $?

#getargx work   &&  echo $? "ret work"
#getargx world  &&  echo $? "ret world"
#getargx hello=  &&  echo $? "ret hello"
#
#getargy verbose= && echo "ret" $? echo "found verbose:" $FOUNDVAL
#getargy verbose2= && echo "ret" $? echo "found verbose2:" $FOUNDVAL
#
#tmpshell "Testing $ "
#tmpshell
#loadmods
#startvts
#loaddevs

# EOF
