#!/bin/bash

SUL="/var/log/startuplogs"
mkdir -p $SUL
SULERR=$SUL/log_err_start; SULOUT=$SUL/log_out_start

if [ ! -f  $SULERR ] ; then
    date > $SULERR
fi
if [ ! -f  $SULOUT ] ; then
    date > $SULOUT
fi

if [ -f /var/tmp/curruser ] ; then
    read -r USERX < /var/tmp/curruser
else
    USERX=root
fi

if [ -f /var/tmp/currdisp ] ; then
    read -r DDDD < /var/tmp/currdisp
else
    DDDD=:0
fi

#echo "Starting session as USER: '$USERX' DISPLAY: '$DDDD' Exec: $XXXX"
export DISPLAY=$DDDD
echo "Starting $USERX on $DISPLAY" >> $SULOUT
su - "$USERX" -c "/usr/bin/xfce4-session --display=$DDDD" >>"$SULOUT" 2>>"$SULERR"

# EOF
