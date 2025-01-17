#!/bin/bash

# Our lib (note: in different dir on test)
. ../shlib/preinitlib.sh

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

# EOF
