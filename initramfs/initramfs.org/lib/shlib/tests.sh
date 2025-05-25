#!/bin/bash

# Run from initramfs root
VERBOSE=1
TESTME=1

. lib/shlib/comlin.sh

CMDLINE="Hell=1 heaven=12"
#CMDLINE=" "

#getargs_test() {
#
#    echo "getargs_test" $@
#
#    for oo in $CMDLINE; do
#        #echo "Iter:""'"$oo"'"
#        #[ "$oo" = "$1" ] && { [ "$RDDEBUG" = "yes" ] && set -x; return 0; }
#        if [ "${oo%=*}" = "${1%=}" ]; then
#            echo "Found: '${oo%=*} = "${oo#*=}"'"
#            #printf -v ${2} "%s" "${oo%=*}"
#            #printf -v ${3} "%s", "${oo#*=}"
#            read $2 <<<  "${oo%=*}"
#            read $3 <<< "${oo#*=}"
#        fi
#    done
#}

loadmods

#getargs_test heaven= COMX VALX
#echo "FOUND COM: '"$COMX"'"
#echo "FOUND VAL: '"$VALX"'"

# EOF
